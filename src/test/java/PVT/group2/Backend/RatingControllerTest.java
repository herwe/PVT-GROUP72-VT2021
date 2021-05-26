package PVT.group2.Backend;

import org.json.JSONObject;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.autoconfigure.web.servlet.AutoConfigureMockMvc;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.MvcResult;
import org.springframework.test.web.servlet.RequestBuilder;
import org.springframework.test.web.servlet.request.MockMvcRequestBuilders;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

@SpringBootTest
@AutoConfigureMockMvc
public class RatingControllerTest {
    @Autowired
    private MockMvc mvc;

    final int INVALID_PARKID = 2000;
    final int VALID_PARKID = 1;
    final int INVALID_VALUE_LOW = 0;
    final int INVALID_VALUE_HIGH = 6;
    final int VALID_VALUE = 3;

    @Test
    public void slashAddWithInvalidPARKIDReturnsError() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.post("/rating/add?parkID=" + INVALID_PARKID + "&value=" + VALID_VALUE);
        MvcResult result = mvc.perform(requestBuilder).andReturn();
        assertEquals("Error", result.getResponse().getContentAsString());
    }

    @Test
    public void slashAddWithTooLowValueReturnsError() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.post("/rating/add?parkID=" + VALID_PARKID + "&value=" + INVALID_VALUE_LOW);
        MvcResult result = mvc.perform(requestBuilder).andReturn();
        assertEquals("Error", result.getResponse().getContentAsString());
    }

    @Test
    public void slashAddWithTooHighValueReturnsError() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.post("/rating/add?parkID=" + VALID_PARKID + "&value=" + INVALID_VALUE_HIGH);
        MvcResult result = mvc.perform(requestBuilder).andReturn();
        assertEquals("Error", result.getResponse().getContentAsString());
    }

    @Test
    public void slashByIDWithInvalidIDReturnsNULL() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.get("/rating/byID?parkID=" + INVALID_PARKID);
        MvcResult result = mvc.perform(requestBuilder).andReturn();
        assertEquals("null", result.getResponse().getContentAsString());
    }

    @Test
    public void slashByIDWithValidIDReturnsEntry() throws Exception {
        RequestBuilder requestBuilder = MockMvcRequestBuilders.get("/rating/byID?parkID=" + VALID_PARKID);
        MvcResult result = mvc.perform(requestBuilder).andReturn();
        assertEquals(VALID_PARKID, new JSONObject(result.getResponse().getContentAsString()).getInt("parkID"));
    }
}
