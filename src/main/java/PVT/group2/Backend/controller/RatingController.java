package PVT.group2.Backend.controller;

import PVT.group2.Backend.model.Rating;
import PVT.group2.Backend.repository.RatingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import java.util.Optional;

@Controller
@RequestMapping("rating")
public class RatingController {
    @Autowired

    private RatingRepository ratingRepository;

    @GetMapping("/all")
    public @ResponseBody Iterable<Rating> all() {
        return ratingRepository.findAll();
    }

    @GetMapping("/byID")
    public @ResponseBody
    Optional<Rating> getRatingByRating(@RequestParam Integer parkID) {
        return ratingRepository.findById(parkID);
    }

    @PostMapping("/add")
    public @ResponseBody String addRating(@RequestParam Integer parkID, @RequestParam Integer value) {
        if (parkExists(parkID) && isValidValue(value)) {
            updateRatingValue(parkID, value);
        }
        else {
            return "Error";
        }
        return "Rating saved";
    }

    private boolean parkExists(Integer parkID) {
        return ratingRepository.existsById(parkID);
    }

    private boolean isValidValue(Integer value) {
        return value >= 1 && value <= 5;
    }

    private void updateRatingValue(Integer parkID, Integer value) {
        Rating r = ratingRepository.findById(parkID).get();
        r.updateValue(value);
        ratingRepository.save(r);
    }
}
