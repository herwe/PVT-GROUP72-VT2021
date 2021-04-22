package PVT.group2.Backend;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertThrows;


@SpringBootTest
class BackendApplicationTests {

    @Test
    void contextLoads() {
    }

    @Test
    void testHelloReturnsCorrectInput() {
        assertEquals("Hello Peter", new BackendApplication().hello("Peter"), "Error in Hello with strings");
    }

    @Test
    void testHelloWitNumbers() {
        assertEquals("Hello 14", new BackendApplication().hello("14"), "Error in hello with numbers");
    }

    @Test
    void testCalculateBasicCalculations(){
        assertEquals(5, new BackendApplication().calculate(2,3, '+'), "failed plus calculation");
        assertEquals(2, new BackendApplication().calculate(5,3,'-'), "failed subtraction calculation");
        assertEquals(2, new BackendApplication().calculate(4,2,'/'), "failed division calculation");
        assertEquals(9, new BackendApplication().calculate(3,3,'*'), "failed multiplication calculation");
    }

    @Test
    void testCalculateThrowsExceptionOnDivisionByZero(){
        BackendApplication test = new BackendApplication();
       assertThrows(ArithmeticException.class, () -> test.calculate(5,0, '/'), "you can't divide by 0");


    }
}