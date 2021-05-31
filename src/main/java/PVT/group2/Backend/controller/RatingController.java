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

    private final int LOWEST_RATING_VALUE = 1;
    private final int HIGHEST_RATING_VALUE = 5;

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

    //Queries the data base wether the specified park exists or not.
    private boolean parkExists(Integer parkID) {
        return ratingRepository.existsById(parkID);
    }

    //Lowest value accepted is 1 and highest 5;
    private boolean isValidValue(Integer value) {
        return value >= LOWEST_RATING_VALUE && value <= HIGHEST_RATING_VALUE;
    }

    //Updates value in database.
    private void updateRatingValue(Integer parkID, Integer value) {
        Rating r = ratingRepository.findById(parkID).get();
        r.updateValue(value);
        ratingRepository.save(r);
    }
}
