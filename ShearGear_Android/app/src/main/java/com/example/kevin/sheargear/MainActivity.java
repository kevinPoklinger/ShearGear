package com.example.kevin.sheargear;

import android.content.Intent;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.Environment;
import android.support.v7.app.AppCompatActivity;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.MediaController;
import android.widget.TextView;
import android.widget.VideoView;

import com.parse.Parse;

public class MainActivity extends AppCompatActivity {

    Typeface typeface_300;
    Typeface typeface_500;
    Typeface typeface_700;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_main);

        Parse.initialize(new Parse.Configuration.Builder(this)
                .applicationId("twEStVywQyEjoSk1BCGkVaWfzzLhkOuzQaT0W0bM")
                .clientKey("YpJ2EbJ4twnPAAqnYfn1D9hLrpYmyJWjGF7TwbQF")
                .server("https://parseapi.back4app.com/").build()
        );

        typeface_300 = Typeface.createFromAsset(getAssets(),  "museo300-Regular.otf");
        typeface_500 = Typeface.createFromAsset(getAssets(),  "museo500-Regular.otf");
        typeface_700 = Typeface.createFromAsset(getAssets(),  "museo700-Regular.otf");

        TextView title = (TextView) findViewById(R.id.main_title);
        TextView slogan = (TextView) findViewById(R.id.main_slogan);
        title.setTypeface(typeface_700);
        slogan.setTypeface(typeface_500);

        Button btn_Subscription = (Button) findViewById(R.id.btn_subscriptions);
        //Button btn_forgot = (Button) findViewById(R.id.btn_forgot_password);
        Button contact = (Button) findViewById(R.id.btn_contact_us);
        //Button login = (Button) findViewById(R.id.btn_login);

        btn_Subscription.setTypeface(typeface_500);
        //btn_forgot.setTypeface(typeface_500);
        contact.setTypeface(typeface_500);
        //login.setTypeface(typeface_500);

        btn_Subscription.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Intent productIntent = new Intent(MainActivity.this, ProductDetailActivity.class);
                startActivity(productIntent);
            }
        });

        VideoView videoView = (VideoView) findViewById(R.id.video_view);
        MediaController mediaController= new MediaController(this);
        mediaController.setAnchorView(videoView);

        int id = this.getRawResIdByName("pucki33_52217_v2");
        Uri uri= Uri.parse("android.resource://" + getPackageName() + "/" + id);
        videoView.setMediaController(mediaController);
        videoView.setVideoURI(uri);
        videoView.requestFocus();
        videoView.start();
    }

    public int getRawResIdByName(String resName) {
        String pkgName = this.getPackageName();
        // Return 0 if not found.
        int resID = this.getResources().getIdentifier(resName, "raw", pkgName);
        Log.i("AndroidVideoView", "Res Name: " + resName + "==> Res ID = " + resID);
        return resID;
    }
}
