package PVT.group2.Backend;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class BackendApplication extends SpringBootServletInitializer {

    public static void main(String[] args) {
        SpringApplication.run(BackendApplication.class, args);
    }

    @GetMapping("/hello")
    public String hello(@RequestParam(value = "name", defaultValue = "World") String name) {
        return String.format("Hello %s", name);
    }

    @GetMapping("/")
    public String helloNothing() {
        return String.format("Hello there");
    }
    @GetMapping("/maths")
    public int calculate(@RequestParam(value = "left", defaultValue = "0") int left,
                         @RequestParam(value = "right", defaultValue = "0") int right,
                         @RequestParam(value = "operator", defaultValue = "+") char operator) throws ArithmeticException {

        switch (operator) {
            case '-':
                return left - right;
            case '*':
                return left * right;
            case '/':
                if (right == 0) throw new ArithmeticException("you can't divide by zero");
                return left / right;
            default:
                return left + right;
        }


    }

}
