package PVT.group2.Backend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertEquals;


@SpringBootTest
class BackendApplicationTests {

	@Test
	void contextLoads() {
	}

	@Test
	void testHello() {
		String out = new BackendApplication().hello("Peter");

		assertEquals("Hello Peter", out, "Error in Hello");
	}

}