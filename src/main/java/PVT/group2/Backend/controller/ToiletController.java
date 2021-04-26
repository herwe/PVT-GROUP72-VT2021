package PVT.group2.Backend.controller;

import PVT.group2.Backend.model.Toilet;
import PVT.group2.Backend.repository.ToiletRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("wc")   //Is found at server.example/wc
public class ToiletController {
    @Autowired

    private ToiletRepository toiletRepository;  //The interface to the database.

    /**
     * Adds a toilet with specified attributes.
     * @param latitude Latitude coordinates.
     * @param longitude Longitude coordinates.
     * @param operational If it is in working condition or not.
     * @return Signal that adding is completed.
     */
    @PostMapping("/add")
    public @ResponseBody
    String addNewWasteBin (@RequestParam double latitude, @RequestParam double longitude, @RequestParam boolean operational, @RequestParam boolean AccessibilityAdapted) {
        toiletRepository.save(new Toilet(latitude, longitude, operational, AccessibilityAdapted));
        return "Saved";
    }

    /**
     * Returns all toilets in the database.
     * @return all toilets.
     */
    @GetMapping("/all")
    public @ResponseBody Iterable<Toilet> all() {
        return toiletRepository.findAll();
    }

    /**
     * Returns all operational toilets in the database.
     * @return all toilets x WHERE x.operational = true in the database.
     */
    @GetMapping("/operational")
    public @ResponseBody Iterable<Toilet> allOperational() {
        return toiletRepository.findByOperationalTrue();
    }

    @GetMapping("/adapted")
    public @ResponseBody Iterable<Toilet> allAccessibilityAdapted() {
        return toiletRepository.findByAccessibilityAdaptedTrue();
    }
}
