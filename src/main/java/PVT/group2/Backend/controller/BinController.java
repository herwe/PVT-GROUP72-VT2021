package PVT.group2.Backend.controller;

import PVT.group2.Backend.model.Bin;
import PVT.group2.Backend.repository.BinRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

//See ToiletController.java for docs, (too similar for me to bother).
@Controller
@RequestMapping("bins")
public class BinController {
    @Autowired

    private BinRepository binRepository;

    @GetMapping("/all")
    public @ResponseBody Iterable<Bin> all() {
        return binRepository.findAll();
    }
}
