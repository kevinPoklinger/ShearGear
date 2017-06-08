package com.example.kevin.sheargear;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Paint;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.SaveCallback;
import com.sendgrid.SendGrid;
import com.sendgrid.SendGridException;

import java.io.IOException;
import java.io.StreamCorruptedException;

public class PlanActivity extends AppCompatActivity {

    private ProgressDialog mProgressDialog;

    Typeface typeface_300;
    Typeface typeface_500;
    Typeface typeface_700;

    Button firstPlan;
    Button secondPlan;
    Button thirdPlan;
    Button forthPlan;
    Button fifthPlan;
    Button sixthPlan;
    Button seventhPlan;

    Button selectedButton;

    TextView selectedPlan;

    int selectedIndex = -1;

    String selectedHand;
    String selectedBladeType;
    String selectedLength;
    String selectedFreeEngraving;
    String selectedColors;
    String selectedGarmentSize;
    String selectedPreferredHandleType;
    String likeEngraved;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.plan_layout);

        selectedHand = getIntent().getStringExtra("Hand");
        selectedBladeType = getIntent().getStringExtra("BladeType");
        selectedLength = getIntent().getStringExtra("Length");
        selectedFreeEngraving = getIntent().getStringExtra("FreeEngraving");
        selectedColors = getIntent().getStringExtra("Colors");
        selectedGarmentSize = getIntent().getStringExtra("GarmentSize");
        selectedPreferredHandleType = getIntent().getStringExtra("HandleyType");
        likeEngraved = getIntent().getStringExtra("LikeEngraved");

        typeface_300 = Typeface.createFromAsset(getAssets(),  "museo300-Regular.otf");
        typeface_500 = Typeface.createFromAsset(getAssets(),  "museo500-Regular.otf");
        typeface_700 = Typeface.createFromAsset(getAssets(),  "museo700-Regular.otf");
        View superView = (View) findViewById(R.id.super_view);
        overrideFonts(this, superView);

        firstPlan = (Button) findViewById(R.id.first_plan);
        secondPlan = (Button) findViewById(R.id.second_plan);
        thirdPlan = (Button) findViewById(R.id.third_plan);
        forthPlan = (Button) findViewById(R.id.forth_plan);
        fifthPlan = (Button) findViewById(R.id.fifth_plan);
        sixthPlan = (Button) findViewById(R.id.sixth_plan);
        seventhPlan = (Button) findViewById(R.id.seventh_plan);

        firstPlan.setPaintFlags(firstPlan.getPaintFlags() | Paint.UNDERLINE_TEXT_FLAG);
        secondPlan.setPaintFlags(secondPlan.getPaintFlags() | Paint.UNDERLINE_TEXT_FLAG);
        thirdPlan.setPaintFlags(thirdPlan.getPaintFlags() | Paint.UNDERLINE_TEXT_FLAG);
        forthPlan.setPaintFlags(forthPlan.getPaintFlags() | Paint.UNDERLINE_TEXT_FLAG);
        fifthPlan.setPaintFlags(fifthPlan.getPaintFlags() | Paint.UNDERLINE_TEXT_FLAG);
        sixthPlan.setPaintFlags(sixthPlan.getPaintFlags() | Paint.UNDERLINE_TEXT_FLAG);
        seventhPlan.setPaintFlags(seventhPlan.getPaintFlags() | Paint.UNDERLINE_TEXT_FLAG);

        selectedPlan = (TextView) findViewById(R.id.selected_plan);

        firstPlan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                removeSelectedButton();
                selectedIndex = 0;
                selectedPlan.setText("Selected Plan: " + firstPlan.getText());
                selectedButton = firstPlan;
                setSelectedButton();
            }
        });

        secondPlan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                removeSelectedButton();
                selectedIndex = 1;
                selectedPlan.setText("Selected Plan: " + secondPlan.getText());
                selectedButton = secondPlan;
                setSelectedButton();
            }
        });

        thirdPlan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                removeSelectedButton();
                selectedIndex = 2;
                selectedPlan.setText("Selected Plan: " + thirdPlan.getText());
                selectedButton = thirdPlan;
                setSelectedButton();
            }
        });

        forthPlan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                removeSelectedButton();
                selectedIndex = 3;
                selectedPlan.setText("Selected Plan: " + forthPlan.getText());
                selectedButton = forthPlan;
                setSelectedButton();
            }
        });

        fifthPlan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                removeSelectedButton();
                selectedIndex = 4;
                selectedPlan.setText("Selected Plan: " + fifthPlan.getText());
                selectedButton = fifthPlan;
                setSelectedButton();
            }
        });

        sixthPlan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                removeSelectedButton();
                selectedIndex = 5;
                selectedPlan.setText("Selected Plan: " + sixthPlan.getText());
                selectedButton = sixthPlan;
                setSelectedButton();
            }
        });

        seventhPlan.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                removeSelectedButton();
                selectedIndex = 5;
                selectedPlan.setText("Selected Plan: " + seventhPlan.getText());
                selectedButton = seventhPlan;
                setSelectedButton();
            }
        });

        Button continueButton = (Button) findViewById(R.id.continue_button);
        continueButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (selectedIndex == -1) {
                    showAlert("Please select a plan.");
                    return;
                }

                PlanActivity.this.showProgress();
                ParseObject product = new ParseObject("Product");
                product.put("Hand", selectedHand);
                product.put("BladeType", selectedBladeType);
                product.put("LengthPreference", selectedLength);
                product.put("FreeEngraving", selectedFreeEngraving);
                product.put("LikeEngraved", likeEngraved);
                product.put("FavoriteColors", selectedColors);
                product.put("GarmentSize", selectedGarmentSize);
                product.put("PreferredHandleType", selectedPreferredHandleType);
                product.put("DeliveryFrequency", selectedPlan.getText().toString());
                product.saveInBackground(new SaveCallback() {
                    @Override
                    public void done(ParseException e) {
                        PlanActivity.this.hideProgress();
                        if (e != null) {
                            showAlert("Failed to submit");
                        }
                        else {
                            Intent paymentIntent = new Intent(PlanActivity.this, PaymentDetailActivity.class);
                            startActivity(paymentIntent);

                            String body = "<p>Hand: " + selectedHand + "</p><br><p>Blade Types: " + selectedBladeType + "</p><br><p>Length Preferences: " + selectedLength + "</p><br><p>FREE Engraving: " + selectedFreeEngraving + "</p><br><p>What would you like engraved? " + likeEngraved + "</p><br><p>Favorite Colors: " + selectedColors + "</p><br><p>Garment Size: " + selectedGarmentSize + "</p><br><p>Preferred Handle Type: " + selectedPreferredHandleType + "</p><br><p>Choose Plan/Delivery Frequency: " + selectedPlan.getText().toString() + "</p><br><p>Please check the product https://parse-dashboard.back4app.com/apps/2de0f9ed-b5c5-4780-8cac-845599f3617b/browser/Product</p>";
                            SendEmailASyncTask task = new SendEmailASyncTask(PlanActivity.this,
                                    "kevin.poklinger@gmail.com",
                                    "kevin.poklinger@outlook.com",
                                    "Product Added",
                                    body,
                                    null,
                                    null);
                            task.execute();
                        }
                    }
                });
            }
        });
    }

    void showAlert(String message) {
        AlertDialog alertDialog = new AlertDialog.Builder(PlanActivity.this).create();
        alertDialog.setTitle("Submission Error");
        alertDialog.setMessage(message);
        alertDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "OK",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                });
        alertDialog.show();
    }

    void removeSelectedButton() {
        if (selectedButton == null) return;
        selectedIndex = -1;
        selectedButton.setTextColor(0xFF458DFF);
    }

    void setSelectedButton() {
        if (selectedButton == null) return;
        selectedButton.setTextColor(0xFF00FF00);
    }

    private void overrideFonts(final Context context, final View v) {
        try {
            if (v instanceof ViewGroup) {
                ViewGroup vg = (ViewGroup) v;
                for (int i = 0; i < vg.getChildCount(); i++) {
                    View child = vg.getChildAt(i);
                    overrideFonts(context, child);
                }
            } else if (v instanceof TextView) {
                ((TextView) v).setTypeface(typeface_500);
            }
        } catch (Exception e) {
        }
    }

    void showProgress() {
        if(mProgressDialog == null) {
            mProgressDialog = new ProgressDialog(this);
            mProgressDialog.setCancelable(false);
            mProgressDialog.setCanceledOnTouchOutside(false);
            mProgressDialog.show();
        }
        else {
            mProgressDialog.show();
        }
    }

    void hideProgress() {
        if (mProgressDialog != null && mProgressDialog.isShowing()) {
            mProgressDialog.dismiss();
            mProgressDialog = null;
        }
    }

    public static class SendEmailASyncTask extends AsyncTask<Void, Void, Void> {

        private Context mAppContext;
        private String mMsgResponse;

        private String mTo;
        private String mFrom;
        private String mSubject;
        private String mText;
        private Uri mUri;
        private String mAttachmentName;

        public SendEmailASyncTask(Context context, String mTo, String mFrom, String mSubject,
                                  String mText, Uri mUri, String mAttachmentName) {
            this.mAppContext = context.getApplicationContext();
            this.mTo = mTo;
            this.mFrom = mFrom;
            this.mSubject = mSubject;
            this.mText = mText;
            this.mUri = mUri;
            this.mAttachmentName = mAttachmentName;
        }

        @Override
        protected Void doInBackground(Void... params) {

            try {
                SendGrid sendgrid = new SendGrid("sheargear", "ShearGear01!");

                SendGrid.Email email = new SendGrid.Email();

                // Get values from edit text to compose email
                // TODO: Validate edit texts
                email.addTo(mTo);
                email.setFrom(mFrom);
                email.setSubject(mSubject);
                //email.setText(mText);
                email.setHtml(mText);

                // Attach image
                if (mUri != null) {
                    email.addAttachment(mAttachmentName, mAppContext.getContentResolver().openInputStream(mUri));
                }

                // Send email, execute http request
                SendGrid.Response response = sendgrid.send(email);
                mMsgResponse = response.getMessage();

                Log.d("SendAppExample", mMsgResponse);

            } catch (SendGridException | IOException e) {
                Log.e("SendAppExample", e.toString());
            }

            return null;
        }

        @Override
        protected void onPostExecute(Void aVoid) {
            super.onPostExecute(aVoid);
        }
    }
}
