CREATE OR REPLACE FUNCTION kualifikasi_atlet() RETURNS TRIGGER AS $$
DECLARE 
    is_qualified integer;
    has_take integer;
    rank_akhir integer;
    minggu integer;
    bulan text;
    tahun integer;
BEGIN
    -- cek di atlet_nonkualifikasi_ujian_kualifikasi
    SELECT COUNT(*)
    FROM ATLET_NONKUALIFIKASI_UJIAN_KUALIFIKASI T
    WHERE T.ID_Atlet = NEW.ID_Atlet AND T.Tahun = NEW.Tahun AND T.Batch = NEW.Batch AND T.Tempat = NEW.Tempat AND T.Tanggal = NEW.Tanggal
    INTO has_take;

    IF (has_take > 0) THEN
        RAISE EXCEPTION 'Atlet nonkualifikasi dengan ID % sudah pernah mengikuti ujian ini', NEW.ID_Atlet;
    END IF;

    -- cek di atlet kualifikasi
    SELECT COUNT(*)
    FROM ATLET_KUALIFIKASI A
    WHERE A.ID_Atlet = NEW.ID_Atlet
    INTO is_qualified;

    IF (is_qualified > 0) THEN
        RETURN NULL;
    END IF;

    -- kalau lulus
    SELECT COUNT(*) FROM ATLET_KUALIFIKASI INTO rank_akhir;
    SELECT DATE_PART('week', NEW.Tanggal) INTO minggu;
    SELECT DATE_PART('year', NEW.Tanggal) INTO tahun;
    SELECT TO_CHAR(NEW.Tanggal, 'Month') INTO bulan;
    
    IF (NEW.hasil_lulus = 't') THEN 
        INSERT INTO atlet_kualifikasi (id_atlet, world_rank, world_tour_rank) 
        VALUES (NEW.ID_Atlet, rank_akhir, rank_akhir);

        INSERT INTO point_history (id_atlet, minggu_ke, bulan, tahun, total_point)
        VALUES (NEW.ID_Atlet, minggu, bulan, tahun, 50);

        DELETE FROM atlet_nonkualifikasi_ujian_kualifikasi U
        WHERE U.ID_Atlet = NEW.ID_Atlet;

        DELETE FROM atlet_non_kualifikasi A
        WHERE A.ID_Atlet = NEW.ID_Atlet;

        RETURN NULL;

    -- kalau ga lulus
    ELSIF (NEW.hasil_lulus='f') THEN 
        return NEW;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER trigger_2
BEFORE INSERT OR UPDATE ON badudu.ATLET_NONKUALIFIKASI_UJIAN_KUALIFIKASI
FOR EACH ROW
EXECUTE PROCEDURE kualifikasi_atlet();
