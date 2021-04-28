package PVT.group2.Backend.controller;

import PVT.group2.Backend.model.WasteBin;
import PVT.group2.Backend.repository.WasteBinRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

//See ToiletController.java for docs, (too similar for me to bother).
@Controller
@RequestMapping("bins")
public class WasteBinController {
    @Autowired

    private WasteBinRepository wasteBinRepository;

    @GetMapping("/all")
    public @ResponseBody Iterable<WasteBin> all() {
        return wasteBinRepository.findAll();
    }
}
