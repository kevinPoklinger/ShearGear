package com.example.kevin.sheargear;

import android.app.DatePickerDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.graphics.Typeface;
import android.net.Uri;
import android.os.AsyncTask;
import android.os.Bundle;
import android.support.v7.app.AlertDialog;
import android.support.v7.app.AppCompatActivity;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.DatePicker;
import android.widget.EditText;
import android.widget.RadioButton;
import android.widget.Spinner;
import android.widget.TextView;

import com.facebook.common.util.UriUtil;
import com.parse.ParseException;
import com.parse.ParseObject;
import com.parse.SaveCallback;
import com.sendgrid.SendGrid;
import com.sendgrid.SendGridException;
import com.stfalcon.frescoimageviewer.ImageViewer;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.Collections;
import java.util.Locale;

public class PaymentDetailActivity extends AppCompatActivity implements SimpleDatePickerDialog.OnDateSetListener {

    Typeface typeface_300;
    Typeface typeface_500;
    Typeface typeface_700;

    Spinner shipping_country;
    Spinner billing_country;

    private ProgressDialog mProgressDialog;

    EditText contactFirstName;
    EditText contactLastName;
    EditText homePhone;
    EditText workPhone;
    EditText placeOfWork;
    EditText emailAddress;
    EditText shippingStreet;
    EditText billingStreet;
    EditText shippingAddressLine;
    EditText billingAddressLine;
    EditText shippingCity;
    EditText billingCity;
    EditText shippingState;
    EditText billingState;
    EditText shippingZipCode;
    EditText billingZipCode;
    RadioButton businessRadio;
    RadioButton residentalRadio;
    EditText businessName;
    EditText creditNumber;
    EditText expirationDate;
    EditText cvvCode;
    Button cvvLearnMore;
    EditText cardHolderFirstName;
    EditText cardHolderLastName;
    EditText comment;
    Button submitButton;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.payment_detail_layout);

        typeface_300 = Typeface.createFromAsset(getAssets(),  "museo300-Regular.otf");
        typeface_500 = Typeface.createFromAsset(getAssets(),  "museo500-Regular.otf");
        typeface_700 = Typeface.createFromAsset(getAssets(),  "museo700-Regular.otf");
        View superView = (View) findViewById(R.id.super_view);
        overrideFonts(this, superView);

        Locale[] locale = Locale.getAvailableLocales();
        ArrayList<String> countries = new ArrayList<String>();
        String country;
        for( Locale loc : locale ){
            country = loc.getDisplayCountry();
            if( country.length() > 0 && !countries.contains(country) ){
                countries.add( country );
            }
        }
        Collections.sort(countries, String.CASE_INSENSITIVE_ORDER);

        int index = 0;
        for (index = 0; index < countries.size(); index++) {
            String object = countries.get(index);
            if (object.compareTo("United States") == 0) {
                break;
            }
        }
        countries.remove(index);
        countries.add(0, "United States");

        shipping_country = (Spinner) findViewById(R.id.shipping_country);
        billing_country = (Spinner) findViewById(R.id.billing_country);
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this,android.R.layout.simple_spinner_item, countries);
        shipping_country.setAdapter(adapter);
        billing_country.setAdapter(adapter);

        contactFirstName = (EditText) findViewById(R.id.contact_first_name);
        contactLastName = (EditText) findViewById(R.id.contact_second_name);
        homePhone = (EditText) findViewById(R.id.home_phone);
        workPhone = (EditText) findViewById(R.id.work_phone);
        placeOfWork = (EditText) findViewById(R.id.place_of_work);
        emailAddress = (EditText) findViewById(R.id.email);
        shippingStreet = (EditText) findViewById(R.id.shipping_street_address);
        billingStreet = (EditText) findViewById(R.id.billing_street);
        shippingAddressLine = (EditText) findViewById(R.id.shipping_address_line);
        billingAddressLine = (EditText) findViewById(R.id.billing_address_line);
        shippingCity = (EditText) findViewById(R.id.shipping_city);
        billingCity = (EditText) findViewById(R.id.billing_city);
        shippingState = (EditText) findViewById(R.id.shipping_state);
        billingState = (EditText) findViewById(R.id.billing_state);
        shippingZipCode = (EditText) findViewById(R.id.shipping_zipcode);
        billingZipCode = (EditText) findViewById(R.id.billing_zipcode);
        businessRadio = (RadioButton) findViewById(R.id.business_radio);
        residentalRadio = (RadioButton) findViewById(R.id.residental_radio);
        businessName = (EditText) findViewById(R.id.business_name);
        creditNumber = (EditText) findViewById(R.id.credit_number);
        expirationDate = (EditText) findViewById(R.id.expiration_date);
        cvvCode = (EditText) findViewById(R.id.cvv_code);
        cvvLearnMore = (Button) findViewById(R.id.cvv_learnmore);
        cardHolderFirstName = (EditText) findViewById(R.id.card_holder_first_name);
        cardHolderLastName = (EditText) findViewById(R.id.card_holder_last_name);
        comment = (EditText) findViewById(R.id.comment);
        submitButton = (Button) findViewById(R.id.submit_button);

        businessRadio.setChecked(true);
        businessRadio.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (businessRadio.isChecked() == true) {
                    residentalRadio.setChecked(false);
                }
                else {
                    residentalRadio.setChecked(true);
                }
            }
        });

        residentalRadio.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (residentalRadio.isChecked() == true) {
                    businessRadio.setChecked(false);
                }
                else {
                    businessRadio.setChecked(true);
                }
            }
        });

        expirationDate.setOnFocusChangeListener(new View.OnFocusChangeListener() {
            @Override
            public void onFocusChange(View v, boolean hasFocus) {
                if (hasFocus) {
                    SimpleDatePickerDialogFragment datePickerDialogFragment;
                    Calendar calendar = Calendar.getInstance(Locale.getDefault());
                    datePickerDialogFragment = SimpleDatePickerDialogFragment.getInstance(
                            calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH));
                    datePickerDialogFragment.setOnDateSetListener(PaymentDetailActivity.this);
                    datePickerDialogFragment.show(PaymentDetailActivity.this.getSupportFragmentManager(), null);
                }
            }
        });

        expirationDate.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                SimpleDatePickerDialogFragment datePickerDialogFragment;
                Calendar calendar = Calendar.getInstance(Locale.getDefault());
                datePickerDialogFragment = SimpleDatePickerDialogFragment.getInstance(
                        calendar.get(Calendar.YEAR), calendar.get(Calendar.MONTH));
                datePickerDialogFragment.setOnDateSetListener(PaymentDetailActivity.this);
                datePickerDialogFragment.show(PaymentDetailActivity.this.getSupportFragmentManager(), null);
            }
        });

        cvvLearnMore.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Uri uri = new Uri.Builder()
                        .scheme(UriUtil.LOCAL_RESOURCE_SCHEME) // "res"
                        .path(String.valueOf(R.drawable.cvvgraphic))
                        .build();
                Uri[] list = new Uri[]{uri};
                new ImageViewer.Builder(PaymentDetailActivity.this, list).setStartPosition(0).show();
            }
        });
/*
        ArrayList<String> cardTypes = new ArrayList<String>(Arrays.asList("Visa", "Mastercard", "Amex", "Discover"));
        ArrayAdapter<String> cardAdapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, cardTypes);
        cardAdapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        creditNumber.setAdapter(cardAdapter);
*/

        submitButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (checkForm() == false) {
                    return;
                }

                showProgress();
                ParseObject paymentInfo = new ParseObject("PaymentInfo");
                paymentInfo.put("firstName", contactFirstName.getText().toString());
                paymentInfo.put("lastName", contactLastName.getText().toString());
                paymentInfo.put("homeCellPhone", homePhone.getText().toString());
                paymentInfo.put("workPhone", workPhone.getText().toString());
                paymentInfo.put("placeOfWork", placeOfWork.getText().toString());
                paymentInfo.put("email", emailAddress.getText().toString());
                paymentInfo.put("shipStreetAddress", shippingStreet.getText().toString());
                paymentInfo.put("shipAddressLine2", shippingAddressLine.getText().toString());
                paymentInfo.put("shipCity", shippingCity.getText().toString());
                paymentInfo.put("shipState", shippingState.getText().toString());
                paymentInfo.put("shipZipCode", shippingZipCode.getText().toString());
                paymentInfo.put("shipCountry", shipping_country.getSelectedItem().toString());

                if (businessRadio.isChecked() == true) {
                    paymentInfo.put("IsBusiness", true);
                }
                else {
                    paymentInfo.put("IsBusiness", true);
                }
                paymentInfo.put("businessName", businessName.getText().toString());
                paymentInfo.put("billStreetAddress", billingStreet.getText().toString());
                paymentInfo.put("billAddressLine2", billingAddressLine.getText().toString());
                paymentInfo.put("billCity", billingCity.getText().toString());
                paymentInfo.put("billState", billingState.getText().toString());
                paymentInfo.put("billZipCode", billingZipCode.getText().toString());
                paymentInfo.put("billCountry", billing_country.getSelectedItem().toString());
                paymentInfo.put("cardNumber", creditNumber.getText().toString());
                paymentInfo.put("expirationDate", expirationDate.getText().toString());
                paymentInfo.put("cvvCode", cvvCode.getText().toString());
                paymentInfo.put("cardHolderFirstName", cardHolderFirstName.getText().toString());
                paymentInfo.put("cardHolderLastName", cardHolderLastName.getText().toString());
                paymentInfo.put("comments", comment.getText().toString());

                paymentInfo.saveInBackground(new SaveCallback() {
                    @Override
                    public void done(ParseException e) {
                        PaymentDetailActivity.this.hideProgress();
                        if (e != null) {
                            showAlert("Failed to submit");
                        }
                        else {
                            Intent success = new Intent(PaymentDetailActivity.this, SuccessActivity.class);
                            startActivity(success);

                            String body = "<p>Contract Name: " + contactFirstName.getText().toString() + " " + contactLastName.getText().toString() + "</p><br>" +
                                    "<p>Home or Cell Phone: " + homePhone.getText().toString() + "</p><br>" +
                                    "<p>Work Phone: " + workPhone.getText().toString() + "</p><br>" +
                                    "<p>Place of Work: " + placeOfWork.getText().toString() + "</p><br>" +
                                    "<p>Email: " + emailAddress.getText().toString() + "</p><br>" +
                                    "<h2>Shipping Address</h2><br>" +
                                    "<p>" + shippingStreet.getText().toString() + "</p><br>" +
                                    "<p>" + shippingAddressLine.getText().toString() + "</p><br>" +
                                    "<p>" + shippingCity.getText().toString() + "</p><br>" +
                                    "<p>" + shippingState.getText().toString() + "</p><br>" +
                                    "<p>" + shippingZipCode.getText().toString() + "</p><br>" +
                                    "<p>" + shipping_country.getSelectedItem().toString() + "</p><br>" +
                                    "<p>Business Name: " + businessName.getText().toString() + "</p><br>" +
                                    "<h2>Billing Address</h2><br>" +
                                    "<p>" + billingStreet.getText().toString() + "</p><br>" +
                                    "<p>" + billingAddressLine.getText().toString() + "</p><br>" +
                                    "<p>" + billingCity.getText().toString() + "</p><br>" +
                                    "<p>" + billingState.getText().toString() + "</p><br>" +
                                    "<p>" + billingZipCode.getText().toString() + "</p><br>" +
                                    "<p>" + billing_country.getSelectedItem().toString() + "</p><br>" +
                                    "<p>Credit or Debit Card Number: " + creditNumber.getText().toString() + "</p><br>" +
                                    "<p>Expiration Date: " + expirationDate.getText().toString() + "</p><br>" +
                                    "<p>CVV Code: " + cvvCode.getText().toString() + "</p><br>" +
                                    "<p>Cardholder Name: " + cardHolderFirstName.getText().toString() + " " + cardHolderLastName.getText().toString() + "</p><br>" +
                                    "<p>Comments and Special instructions:</p><br><p>" + comment.getText().toString() + "</p><br>" +
                                    "<p>Please check payment information https://parse-dashboard.back4app.com/apps/2de0f9ed-b5c5-4780-8cac-845599f3617b/browser/PaymentInfo</p>";
                            PlanActivity.SendEmailASyncTask task = new PlanActivity.SendEmailASyncTask(PaymentDetailActivity.this,
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

    @Override
    public void onDateSet(int year, int monthOfYear) {
        expirationDate.setText(DateDisplayUtils.formatMonthYear(year, monthOfYear));
    }

    final Calendar myCalendar = Calendar.getInstance();
    DatePickerDialog.OnDateSetListener date = new DatePickerDialog.OnDateSetListener() {

        @Override
        public void onDateSet(DatePicker view, int year, int monthOfYear,
                              int dayOfMonth) {
            // TODO Auto-generated method stub
            myCalendar.set(Calendar.YEAR, year);
            myCalendar.set(Calendar.MONTH, monthOfYear);
            myCalendar.set(Calendar.DAY_OF_MONTH, dayOfMonth);
            updateLabel();
        }

    };

    private void updateLabel() {

        String myFormat = "MM/dd/yy"; //In which you need put here
        SimpleDateFormat sdf = new SimpleDateFormat(myFormat, Locale.US);

        expirationDate.setText(sdf.format(myCalendar.getTime()));
    }

    String emailPattern = "[a-zA-Z0-9._-]+@[a-z]+\\.+[a-z]+";

    boolean checkForm() {
        if (isEmpty(contactFirstName) || isEmpty(contactLastName)) {
            showAlert("Contact Name", false);
            return false;
        }

        if (isEmpty(homePhone)) {
            showAlert("Home or Cell Phone", false);
            return false;
        }

        if (homePhone.getText().toString().length() != 10) {
            showAlert("Please enter a valid phone number.", true);
            return false;
        }

        if (isEmpty(emailAddress)) {
            showAlert("Email Address", false);
            return false;
        }

        String email = emailAddress.getText().toString().trim();
        if (email.matches(emailPattern) == false)
        {
            showAlert("Please enter a valid email address.", true);
            return false;
        }

        if (isEmpty(shippingStreet) || isEmpty(shippingCity) || isEmpty(shippingState) || isEmpty(shippingZipCode)) {
            showAlert("Shipping Address", false);
            return false;
        }

        if (isEmpty(expirationDate)) {
            showAlert("Expiration Date", false);
            return false;
        }

        if (isEmpty(creditNumber)) {
            showAlert("Credit or Debit Card Number", false);
            return false;
        }

        if (isEmpty(cvvCode)) {
            showAlert("CVV Code", false);
            return false;
        }

        if (isEmpty(cardHolderFirstName) || isEmpty(cardHolderLastName)) {
            showAlert("Cardholder Name", false);
            return false;
        }

        return true;
    }

    boolean isEmpty(EditText text) {
        if (text.getText().toString().compareTo("") == 0) {
            return true;
        }
        return false;
    }

    void showAlert(String message, boolean bFull) {
        AlertDialog alertDialog = new AlertDialog.Builder(PaymentDetailActivity.this).create();
        alertDialog.setTitle("Submission Error");
        if (bFull == true) {
            alertDialog.setMessage(message);
        }
        else {
            alertDialog.setMessage(message + " field is required. Please enter a value.");
        }
        alertDialog.setButton(AlertDialog.BUTTON_NEUTRAL, "OK",
                new DialogInterface.OnClickListener() {
                    public void onClick(DialogInterface dialog, int which) {
                        dialog.dismiss();
                    }
                });
        alertDialog.show();
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

    private static class SendmailASyncTask extends AsyncTask<Void, Void, Void> {

        private Context mAppContext;
        private String mMsgResponse;

        private String mTo;
        private String mFrom;
        private String mSubject;
        private String mText;
        private Uri mUri;
        private String mAttachmentName;

        public SendmailASyncTask(Context context, String mTo, String mFrom, String mSubject,
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

    void showAlert(String message) {
        AlertDialog alertDialog = new AlertDialog.Builder(PaymentDetailActivity.this).create();
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
}
