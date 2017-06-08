package com.example.kevin.sheargear;

import android.content.Context;
import android.content.Intent;
import android.graphics.Typeface;
import android.graphics.drawable.Animatable;
import android.graphics.drawable.Drawable;
import android.net.Uri;
import android.os.Bundle;
import android.support.v7.app.AppCompatActivity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ArrayAdapter;
import android.widget.Button;
import android.widget.EditText;
import android.widget.Spinner;
import android.widget.TextView;

import com.facebook.common.util.UriUtil;
import com.facebook.drawee.backends.pipeline.Fresco;
import com.facebook.drawee.backends.pipeline.PipelineDraweeControllerBuilder;
import com.facebook.drawee.controller.BaseControllerListener;
import com.facebook.drawee.view.SimpleDraweeView;
import com.facebook.imagepipeline.image.ImageInfo;
import com.stfalcon.frescoimageviewer.ImageViewer;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

import io.apptik.widget.multiselectspinner.MultiSelectSpinner;
import me.relex.photodraweeview.PhotoDraweeView;


public class ProductDetailActivity extends AppCompatActivity {

    Typeface typeface_300;
    Typeface typeface_500;
    Typeface typeface_700;

    Button continueButton;
    Button handleTypeButton;
    Button freeEngravingButton;

    EditText likeEngravedInput;

    Spinner handSpinner;
    Spinner bladeSpinner;
    Spinner freeEngravingSpinner;

    MultiSelectSpinner favoriteColorSpinner;
    MultiSelectSpinner lengthSpinner;
    Spinner garmentSizeSpinner;
    Spinner handleTypeSpinner;

    ArrayList<String> hands = new ArrayList<String>(Arrays.asList("Right Handed", "Left Handed"));
    ArrayList<String> bladeTypes = new ArrayList<String>(Arrays.asList("Mix of straight & curved", "curved only", "straight only"));
    ArrayList<String> lengthTypes = new ArrayList<String>(Arrays.asList("All Sizes 7\"-9.5\"", "Medium 7-8.5\"", "Large: 8\"-10\""));
    ArrayList<String> freeEngravings = new ArrayList<String>(Arrays.asList("Absolutely!", "No, Thank you"));
    ArrayList<String> colors = new ArrayList<String>(Arrays.asList("Clear/White", "Black", "Pink", "Purple", "Dark Green", "Lime", "Red", "Blue", "Turquoise", "Yellow", "Orange"));
    ArrayList<String> garmentSizes = new ArrayList<String>(Arrays.asList("small", "medium", "large", "XL", "XXL", "3X", "4X", "5X"));
    ArrayList<String> preferredHandleTypes = new ArrayList<String>(Arrays.asList("Even (flippable)", "Offset (Ergo)", "Swivel ($5 surcharge per box)"));

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
        setContentView(R.layout.product_detail_layout);

        Fresco.initialize(getApplicationContext());

        typeface_300 = Typeface.createFromAsset(getAssets(),  "museo300-Regular.otf");
        typeface_500 = Typeface.createFromAsset(getAssets(),  "museo500-Regular.otf");
        typeface_700 = Typeface.createFromAsset(getAssets(),  "museo700-Regular.otf");

        final View superView = (View) findViewById(R.id.super_view);
        overrideFonts(this, superView);

        ((TextView) findViewById(R.id.shear_gear_title)).setTypeface(typeface_500);
        ((TextView) findViewById(R.id.choose_your_preferrence)).setTypeface(typeface_500);
        ((TextView) findViewById(R.id.hand_title)).setTypeface(typeface_500);
        ((TextView) findViewById(R.id.blade_title)).setTypeface(typeface_500);
        ((TextView) findViewById(R.id.free_engraving_title)).setTypeface(typeface_500);
        ((TextView) findViewById(R.id.like_engraved_comment)).setTypeface(typeface_500);
        ((TextView) findViewById(R.id.favorite_color_title)).setTypeface(typeface_500);
        ((TextView) findViewById(R.id.garment_size_title)).setTypeface(typeface_500);
        ((TextView) findViewById(R.id.favorite_color_title)).setTypeface(typeface_500);
        ((TextView) findViewById(R.id.handle_type_title)).setTypeface(typeface_500);
        ((Button) findViewById(R.id.continue_button)).setTypeface(typeface_500);
        ((Button) findViewById(R.id.handle_type_button)).setTypeface(typeface_500);
        ((Button) findViewById(R.id.free_engraving_button)).setTypeface(typeface_500);

        continueButton = (Button) findViewById(R.id.continue_button);
        handleTypeButton = (Button) findViewById(R.id.handle_type_button);
        freeEngravingButton = (Button) findViewById(R.id.free_engraving_button);
        likeEngravedInput = (EditText) findViewById(R.id.like_engraved_input);

        continueButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                selectedHand = handSpinner.getSelectedItem().toString();
                selectedBladeType = bladeSpinner.getSelectedItem().toString();
                selectedFreeEngraving = freeEngravingSpinner.getSelectedItem().toString();
                selectedColors = favoriteColorSpinner.getSelectedItem().toString();
                selectedGarmentSize = garmentSizeSpinner.getSelectedItem().toString();
                selectedPreferredHandleType = handleTypeSpinner.getSelectedItem().toString();
                likeEngraved = likeEngravedInput.getText().toString();
                selectedLength = lengthSpinner.getSelectedItem().toString();

                Intent planIntent = new Intent(ProductDetailActivity.this, PlanActivity.class);

                planIntent.putExtra("Hand", selectedHand);
                planIntent.putExtra("BladeType", selectedBladeType);
                planIntent.putExtra("FreeEngraving", selectedFreeEngraving);
                planIntent.putExtra("Colors", selectedColors);
                planIntent.putExtra("GarmentSize", selectedGarmentSize);
                planIntent.putExtra("HandleyType", selectedPreferredHandleType);
                planIntent.putExtra("LikeEngraved", likeEngraved);
                planIntent.putExtra("Length", selectedLength);

                startActivity(planIntent);
            }
        });

        handleTypeButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Uri uri = new Uri.Builder()
                        .scheme(UriUtil.LOCAL_RESOURCE_SCHEME) // "res"
                        .path(String.valueOf(R.drawable.handletype))
                        .build();
                Uri[] list = new Uri[]{uri};
                new ImageViewer.Builder(ProductDetailActivity.this, list).setStartPosition(0).show();
            }
        });

        freeEngravingButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                Uri uri = new Uri.Builder()
                        .scheme(UriUtil.LOCAL_RESOURCE_SCHEME) // "res"
                        .path(String.valueOf(R.drawable.freeengaging))
                        .build();
                Uri[] list = new Uri[]{uri};
                new ImageViewer.Builder(ProductDetailActivity.this, list).setStartPosition(0).show();
            }
        });

        handSpinner = (Spinner) findViewById(R.id.hand_spinner);
        bladeSpinner = (Spinner) findViewById(R.id.blade_spinner);
        freeEngravingSpinner = (Spinner) findViewById(R.id.free_engraving_spinner);
        garmentSizeSpinner = (Spinner) findViewById(R.id.garment_size_spinner);
        handleTypeSpinner = (Spinner) findViewById(R.id.handle_type_spinner);
        setAdapter(handSpinner, hands);
        setAdapter(bladeSpinner, bladeTypes);
        setAdapter(freeEngravingSpinner, freeEngravings);
        setAdapter(garmentSizeSpinner, garmentSizes);
        setAdapter(handleTypeSpinner, preferredHandleTypes);

        favoriteColorSpinner = (MultiSelectSpinner) findViewById(R.id.favorite_color_spinner);
        ArrayAdapter<String> adapter = new ArrayAdapter <String>(this, android.R.layout.simple_list_item_multiple_choice, colors);
        favoriteColorSpinner.setListAdapter(adapter);

        lengthSpinner = (MultiSelectSpinner) findViewById(R.id.length_spinner);
        ArrayAdapter<String> lengthAdapter = new ArrayAdapter <String>(this, android.R.layout.simple_list_item_multiple_choice, lengthTypes);
        lengthSpinner.setListAdapter(lengthAdapter);
    }

    public void setAdapter(Spinner spinner, ArrayList<String> array) {
        ArrayAdapter<String> adapter = new ArrayAdapter<String>(this, android.R.layout.simple_spinner_item, array);
        adapter.setDropDownViewResource(android.R.layout.simple_spinner_dropdown_item);
        spinner.setAdapter(adapter);
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
}
