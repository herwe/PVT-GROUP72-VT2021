package PVT.group2.Backend;

import org.json.JSONArray;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.junit.jupiter.api.Assertions.assertEquals;


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

    final int PARKS_WITH_GREEN_QUALITY = 984;
    @Test
    void slashGreenReturnsCorrectAmountOfEntries() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.get("/parks/green");
        MvcResult result = mvc.perform(requestBuilder).andReturn();
        assertEquals(PARKS_WITH_GREEN_QUALITY, new JSONArray(result.getResponse().getContentAsString()).length());
    }
}