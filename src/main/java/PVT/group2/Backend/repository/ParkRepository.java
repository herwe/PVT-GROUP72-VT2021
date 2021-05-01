package PVT.group2.Backend.repository;

import PVT.group2.Backend.model.Park;
import org.springframework.data.repository.CrudRepository;

public interface ParkRepository extends CrudRepository<Park, Integer> {
    Iterable<Park> findByGreenTrue();
}
