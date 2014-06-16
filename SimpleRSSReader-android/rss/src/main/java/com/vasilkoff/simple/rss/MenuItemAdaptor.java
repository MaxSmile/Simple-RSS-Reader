package com.vasilkoff.simple.rss;

import android.content.Context;
import android.database.Cursor;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.CursorAdapter;
import android.widget.ImageView;
import android.widget.TextView;

import com.nostra13.universalimageloader.core.ImageLoader;

/**
 * Created by maxim.vasilkov@gmail.com on 16/06/14.
 */

public class MenuItemAdaptor extends CursorAdapter {
    private final LayoutInflater mInflater;
    private NavigationDrawerFragment mFragment;
    private ImageLoader imageLoader = null;


    public MenuItemAdaptor(NavigationDrawerFragment fragment, Cursor cursor) {
        super(fragment.getActivity(), cursor, 0);
        this.mInflater = (LayoutInflater)fragment.getActivity().getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        mFragment = fragment;
        imageLoader = ImageLoader.getInstance();
    }

    @Override
    public View newView(Context context, Cursor cursor, ViewGroup parent) {
        View view = mInflater.inflate(R.layout.menu_item, parent, false);

        bindView(view, context, cursor);
        return view;
    }

    @Override
    public void bindView(View view, Context context, Cursor cursor) {
        String title = cursor.getString(cursor.getColumnIndex(DBHelper.r_description));
        String description = cursor.getString(cursor.getColumnIndex(DBHelper.r_url_record));
        String imageUrl = cursor.getString(cursor.getColumnIndex(DBHelper.r_icon_url));

        TextView tvTitle = (TextView)view.findViewById(R.id.textViewTitle);
        TextView tvDescription = (TextView)view.findViewById(R.id.textViewDescription);
        ImageView picture = (ImageView)view.findViewById(R.id.imageViewPicture);


        tvTitle.setText(title);
        tvDescription.setText(description);
//        imageLoader.displayImage(imageUrl,picture);
    }
}
