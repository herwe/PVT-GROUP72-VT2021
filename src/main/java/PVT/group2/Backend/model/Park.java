package PVT.group2.Backend.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Park {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    private double latitude;
    private double longitude;

    private String name;
    private boolean green;
    private boolean playground;
    private boolean natureplay;
    private boolean calm;
    private boolean ballplay;
    private boolean parkplay;
    private boolean picknick;
    private boolean grill;
    private boolean sleigh;
    private boolean view;
    private boolean forrest;
    private boolean animal;
    private boolean water;
    private boolean out_bath;
    private boolean nature_expr;
    private boolean out_serve;
    private boolean water_play;
    private boolean bath_f;

    public Park(Integer id, double latitude, double longitude, String name, boolean green, boolean playground, boolean natureplay, boolean calm, boolean ballplay, boolean parkplay, boolean picknick, boolean grill, boolean sleigh, boolean view, boolean forrest, boolean animal, boolean water, boolean out_bath, boolean nature_expr, boolean out_serve, boolean water_play, boolean bath_f) {
        this.id = id;
        this.latitude = latitude;

        this.longitude = longitude;
        this.name = name;
        this.green = green;
        this.playground = playground;
        this.natureplay = natureplay;
        this.calm = calm;
        this.ballplay = ballplay;
        this.parkplay = parkplay;
        this.picknick = picknick;
        this.grill = grill;
        this.sleigh = sleigh;
        this.view = view;
        this.forrest = forrest;
        this.animal = animal;
        this.water = water;
        this.out_bath = out_bath;
        this.nature_expr = nature_expr;
        this.out_serve = out_serve;
        this.water_play = water_play;
        this.bath_f = bath_f;
    }

    public Park() {

    }

    public Integer getId() {
        return id;
    }

    public double getLatitude() {
        return latitude;
    }

    public double getLongitude() {
        return longitude;
    }

    public String getName() {
        return name;
    }

    public boolean isGreen() {
        return green;
    }

    public boolean isPlayground() {
        return playground;
    }

    public boolean isNatureplay() {
        return natureplay;
    }

    public boolean isCalm() {
        return calm;
    }

    public boolean isBallplay() {
        return ballplay;
    }

    public boolean isParkplay() {
        return parkplay;
    }

    public boolean isPicknick() {
        return picknick;
    }

    public boolean isGrill() {
        return grill;
    }

    public boolean isSleigh() {
        return sleigh;
    }

    public boolean isView() {
        return view;
    }

    public boolean isForrest() {
        return forrest;
    }

    public boolean isAnimal() {
        return animal;
    }

    public boolean isWater() {
        return water;
    }

    public boolean isOut_bath() {
        return out_bath;
    }

    public boolean isNature_expr() {
        return nature_expr;
    }

    public boolean isOut_serve() {
        return out_serve;
    }

    public boolean isWater_play() {
        return water_play;
    }

    public boolean isBath_f() {
        return bath_f;
    }
}
