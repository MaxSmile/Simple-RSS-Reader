package com.vasilkoff.simple.rss;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.DatabaseUtils;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.os.Handler;
import android.os.Message;
import android.util.Log;

import org.apache.http.NameValuePair;
import org.apache.http.message.BasicNameValuePair;
import org.json.JSONArray;
import org.json.JSONObject;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

/**
 * Created by maxim.vasilkov on 3/12/14.
 */
public class DBHelper extends SQLiteOpenHelper {
    protected static final String TAG = DBHelper.class.getSimpleName();
    private static final String DATABASE_NAME = "channels6.db";
    private static final String TABLE_CHANNELS = "channels";
    private static final int DATABASE_VERSION = 1;



    private static DBHelper instance = null;
    private static SQLiteDatabase db=null;
    private Context context;


    public static final String r_parent_id = "pid";
    public static final String r_url_record = "url";
    public static final String r_description = "descr";
    public static final String r_icon_url = "icon";
    public static final String r_completed = "completed";
    public static final String r_time_stamp  = "record_made";
    public static final String r_noted_data  = "notes_json";
    public static final String r_offline = "offline";




    /**
     * Puts a new record to the Channels table
     * @param data name value pairs
     * @return new record id from the queue table or -1 on failure
     */
    public long addRecord(List<NameValuePair> data) {
        ContentValues values = new ContentValues();
        for (int i = 0; i <data.size(); i++) {
            NameValuePair pair = data.get(i);
            values.put(pair.getName(),pair.getValue());
        }
        long recordId = -1;
        try {
            recordId = db.insertOrThrow(TABLE_CHANNELS,null,values);
        } catch (Exception ex) {
            ex.printStackTrace();
        }
        return recordId;
    }


    /**
     * Marks the record with specified id as sent
     * @param recordIdx
     */
    public static void markAsRead(long recordIdx) {
        db.execSQL("Update "+ TABLE_CHANNELS +" set "+r_completed+"=100 where id="+recordIdx);
    }

    private boolean freshCreated = false;

    private void init() {
        if (freshCreated) {
            // channels by default
            addSimpleRecord("http://vasilkoff.com/feed", "Creator blog", "http://vasilkoff.com/favicon.ico");
            addSimpleRecord("http://feeds.gawker.com/lifehacker/full", "Life hacker", "http://i.kinja-img.com/gawker-media/image/upload/s--rqDhe7s2--/c_fill,fl_progressive,g_center,h_80,q_80,w_80/192oza44hceztpng.png");
        }
    }

    /**
     * override getInstance to use without context parameter
     * @return singleton instance
     */
    public static DBHelper getInstance(Context context) {
        if (instance==null) {
            instance = new DBHelper(context);
            instance.context = context;
            db = instance.getWritableDatabase();
            instance.init();
        }
        return instance;
    }

    /**
     * constructor
     * @param context
     */
    protected DBHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }


    public List<NameValuePair> SimpleRecord(String url,String description,String iconUrl) {
        List<NameValuePair> data = new ArrayList<NameValuePair>();
        data.add(new BasicNameValuePair(r_url_record,url));
        data.add(new BasicNameValuePair(r_description,description));
        data.add(new BasicNameValuePair(r_icon_url,iconUrl));
        return data;
    }

    public long addSimpleRecord(String url,String description,String iconUrl) {
        return addRecord(SimpleRecord(url, description, iconUrl));
    }

    public Cursor getChannels() {
        return db.rawQuery("SELECT rowid _id, * FROM  " + TABLE_CHANNELS +
                " ORDER BY "+r_time_stamp, new String[] {});
    }

    public Cursor getNewsRecords(String channel) {
        return db.rawQuery("SELECT rowid _id,* FROM items WHERE " + r_parent_id + " = ? " +
                " ORDER BY "+r_time_stamp, new String[] {channel});
    }
    
    @Override
    public void onCreate(SQLiteDatabase sqLiteDatabase) {
        sqLiteDatabase.execSQL("create table "+ TABLE_CHANNELS +" ("
                + r_parent_id  + " integer default 0,"
                + r_url_record + " text,"
                + r_offline + " text,"
                + r_description + " text,"
                + r_icon_url + " text,"
                + r_time_stamp + " DATETIME DEFAULT CURRENT_TIMESTAMP,"
                + r_noted_data + " text,"
                + r_completed + " int default 0);");

        freshCreated = true;
    }

    /**
     * deletes all from the synchronization table
     */
    public void emptyChannelsTable() {
        db.execSQL("DELETE FROM "+TABLE_CHANNELS);
    }





    @Override
    public void onUpgrade(SQLiteDatabase sqLiteDatabase, int i, int i2) {

    }

    @Override
    public void onDowngrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        super.onDowngrade(db, oldVersion, newVersion);
    }

    @Override
    public void onOpen(SQLiteDatabase db) {
        super.onOpen(db);
        this.db = db;
    }



}
