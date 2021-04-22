package PVT.group2.Backend.controller;

import PVT.group2.Backend.model.WasteBin;
import PVT.group2.Backend.repository.WasteBinRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

@Controller
@RequestMapping("bins")
public class WasteBinController {
    @Autowired

    private WasteBinRepository wasteBinRepository;

    @PostMapping("/add")
    public @ResponseBody String addNewWasteBin (@RequestParam double latitude, @RequestParam double longitude) {
        wasteBinRepository.save(new WasteBin(latitude, longitude));
        return "Saved";
    }

    @GetMapping("/all")
    public @ResponseBody Iterable<WasteBin> all() {
        return wasteBinRepository.findAll();
    }
}
