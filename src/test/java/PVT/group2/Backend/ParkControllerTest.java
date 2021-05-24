package PVT.group2.Backend;

import PVT.group2.Backend.controller.ParkController;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.autoconfigure.web.servlet.WebMvcTest;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.test.context.junit4.SpringRunner;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;


@SpringBootTest
@AutoConfigureMockMvc
class ParkControllerTest {

    @Autowired
    private MockMvc mvc;

    @Test
    void slashAllReturnsCode200() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.get("/parks/all");
        MvcResult result = mvc.perform(requestBuilder).andReturn();
        assertEquals(200, result.getResponse().getStatus());
    }
}