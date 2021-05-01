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
    private boolean lekplats;
    private boolean naturlek;
    private boolean ro;
    private boolean boll;
    private boolean boll_lek;
    private boolean park_lek;
    private boolean picknick;
    private boolean grill;
    private boolean pulka;
    private boolean view;
    private boolean skog;
    private boolean djur;
    private boolean vatten;
    private boolean utom_bad;
    private boolean natur_upp;
    private boolean ute_serv;
    private boolean vatten_lek;
    private boolean bad;

    public Park(Integer id, double latitude, double longitude, String name, boolean green, boolean lekplats, boolean naturlek, boolean ro, boolean boll, boolean boll_lek, boolean park_lek, boolean picknick, boolean grill, boolean pulka, boolean view, boolean skog, boolean djur, boolean vatten, boolean utom_bad, boolean natur_upp, boolean ute_serv, boolean vatten_lek, boolean bad) {
        this.id = id;
        this.latitude = latitude;

        this.longitude = longitude;
        this.name = name;
        this.green = green;
        this.lekplats = lekplats;
        this.naturlek = naturlek;
        this.ro = ro;
        this.boll = boll;
        this.boll_lek = boll_lek;
        this.park_lek = park_lek;
        this.picknick = picknick;
        this.grill = grill;
        this.pulka = pulka;
        this.view = view;
        this.skog = skog;
        this.djur = djur;
        this.vatten = vatten;
        this.utom_bad = utom_bad;
        this.natur_upp = natur_upp;
        this.ute_serv = ute_serv;
        this.vatten_lek = vatten_lek;
        this.bad = bad;
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

    public boolean isLekplats() {
        return lekplats;
    }

    public boolean isNaturlek() {
        return naturlek;
    }

    public boolean isRo() {
        return ro;
    }

    public boolean isBoll() {
        return boll;
    }

    public boolean isBoll_lek() {
        return boll_lek;
    }

    public boolean isPark_lek() {
        return park_lek;
    }

    public boolean isPicknick() {
        return picknick;
    }

    public boolean isGrill() {
        return grill;
    }

    public boolean isPulka() {
        return pulka;
    }

    public boolean isView() {
        return view;
    }

    public boolean isSkog() {
        return skog;
    }

    public boolean isDjur() {
        return djur;
    }

    public boolean isVatten() {
        return vatten;
    }

    public boolean isUtom_bad() {
        return utom_bad;
    }

    public boolean isNatur_upp() {
        return natur_upp;
    }

    public boolean isUte_serv() {
        return ute_serv;
    }

    public boolean isVatten_lek() {
        return vatten_lek;
    }

    public boolean isBad() {
        return bad;
    }
}
