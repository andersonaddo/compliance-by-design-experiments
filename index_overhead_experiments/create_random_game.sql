insert into tablename(gamename, price, description, supplier) values (
    (SELECT array_to_string(ARRAY (SELECT substring('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' FROM (random() * 36)::int FOR 1) FROM generate_series(1, 50) ), '' )),
    (select floor(random() * 100 + 1)) :: int,
    (SELECT array_to_string(ARRAY (SELECT substring('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' FROM (random() * 36)::int FOR 1) FROM generate_series(1, 300) ), '' )),
    (SELECT array_to_string(ARRAY (SELECT substring('0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' FROM (random() * 36)::int FOR 1) FROM generate_series(1, 50) ), '' ))
);