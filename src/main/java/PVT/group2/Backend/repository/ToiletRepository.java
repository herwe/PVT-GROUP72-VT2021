package PVT.group2.Backend.repository;

import PVT.group2.Backend.model.Toilet;
import org.springframework.data.repository.CrudRepository;

//See https://docs.spring.io/spring-data/jpa/docs/current/reference/html/#reference for how the method is translated by spring in to a query.
public interface ToiletRepository extends CrudRepository<Toilet, Integer> {
    Iterable<Toilet> findByOperationalTrue();
    Iterable<Toilet> findByAdaptedTrue();
}
