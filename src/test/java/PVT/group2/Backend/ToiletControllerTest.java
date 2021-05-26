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
public class ToiletControllerTest {

    @Autowired
    private MockMvc mvc;

    @Test
    void slashAllReturnsCode200() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.get("/wc/all");
        MvcResult result = mvc.perform(requestBuilder).andReturn();
        assertEquals(200, result.getResponse().getStatus());
    }

    final int TOILETS_WITH_OPERATIONAL_QUALITY = 96;
    @Test
    void slashOperationalReturnsCorrectAmountOfEntries() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.get("/wc/operational");
        MvcResult result = mvc.perform(requestBuilder).andReturn();
        assertEquals(TOILETS_WITH_OPERATIONAL_QUALITY, new JSONArray(result.getResponse().getContentAsString()).length());
    }

    final int TOILETS_WITH_ADAPTED_QUALITY = 91;
    @Test
    void slashAdaptedReturnsCorrectAmountOfEntries() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.get("/wc/adapted");
        MvcResult result = mvc.perform(requestBuilder).andReturn();
        assertEquals(TOILETS_WITH_ADAPTED_QUALITY, new JSONArray(result.getResponse().getContentAsString()).length());
    }
}
