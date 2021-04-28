package PVT.group2.Backend.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Bin {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)
    private Integer id;

    private double latitude;
    private double longitude;

    public Bin(double latitude, double longitude) {
        this.latitude = latitude;
        this.longitude = longitude;
    }

    public Bin() {

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
}
