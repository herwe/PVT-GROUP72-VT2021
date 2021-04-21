package PVT.group2.Backend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
class BackendApplicationTests {

	@Test
	void contextLoads() {
	}

	@Test
	void testHello(){
		String out = new BackendApplication().hello("peter");
		assert out.equals("Hello peter");
	}
	@Test
	void testHelloButFailing(){
		String out = new BackendApplication().hello("Peter");
		assert out.equals("Hello peter");
	}
}
