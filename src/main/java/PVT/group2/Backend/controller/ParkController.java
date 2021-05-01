package PVT.group2.Backend.controller;

import PVT.group2.Backend.model.Park;
import PVT.group2.Backend.repository.ParkRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("parks")
public class ParkController {
    @Autowired

    private ParkRepository parkRepository;

    @GetMapping("/all")
    public @ResponseBody Iterable<Park> all() {
        return parkRepository.findAll();
    }

    @GetMapping("/green")
    public @ResponseBody Iterable<Park> green() {
        return parkRepository.findByGreenTrue();
    }
}
