package PVT.group2.Backend.model;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

@Entity
public class Rating {
    @Id
    @GeneratedValue(strategy = GenerationType.AUTO)

    private Integer ParkID;
    private Integer value;

    public Rating(Integer ParkID, Integer value) {
        this.ParkID = ParkID;
        this.value = value;
    }

    public Rating() {}

    public Integer getParkID() {
        return ParkID;
    }

    public Integer getValue() {
        return value;
    }

    public void updateValue(Integer value) {
        if (this.value == 0) {
            this.value = value;
        }
        else {
            this.value = ((this.value + value) / 2);
        }
    }
}
