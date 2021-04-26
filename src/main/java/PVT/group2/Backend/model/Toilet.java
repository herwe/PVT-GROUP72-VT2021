package PVT.group2.Backend.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Toilet {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    private double latitude;
    private double longitude;
    private boolean operational;
    private boolean accessibilityAdapted;

    public Toilet(double latitude, double longitude, boolean operational, boolean accessibilityAdapted) {
        this.latitude = latitude;
        this.longitude = longitude;
        this.operational = operational;
        this.accessibilityAdapted = accessibilityAdapted;
    }

    public Toilet() {

    }

    public void setId(Integer id) {
        this.id = id;
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

    public boolean isOperational() {
        return operational;
    }

    public boolean isAccessibilityAdapted() {
        return accessibilityAdapted;
    }
}
