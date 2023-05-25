CREATE OR REPLACE FUNCTION cek_member() RETURNS TRIGGER AS $$
DECLARE 
    is_exist integer;
BEGIN
    -- cek di member
    SELECT COUNT(*)
    FROM MEMBER M
    WHERE M.email = NEW.email
    INTO is_exist;

    IF (is_exist > 0) THEN
        RAISE EXCEPTION 'Email % sudah pernah digunakan', NEW.email;
    END IF;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_1a
BEFORE INSERT OR UPDATE ON badudu.MEMBER
FOR EACH ROW
EXECUTE PROCEDURE cek_member();


CREATE OR REPLACE FUNCTION cek_atlet() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO atlet_non_kualifikasi (id_atlet) 
    VALUES (NEW.ID);

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_1b
BEFORE INSERT OR UPDATE ON badudu.ATLET
FOR EACH ROW
EXECUTE PROCEDURE cek_atlet();

