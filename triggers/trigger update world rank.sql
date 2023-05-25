CREATE OR REPLACE FUNCTION update_world_rank() RETURNS TRIGGER AS $$
BEGIN
    -- Calculate new ranks
    WITH ranked AS (
        SELECT ID, ROW_NUMBER() OVER (ORDER BY sum_points DESC) AS rank
        FROM (
            SELECT ID_Atlet AS ID, SUM(Total_Point) as sum_points
            FROM badudu.POINT_HISTORY
            WHERE Tahun = EXTRACT(YEAR FROM CURRENT_DATE)
            GROUP BY ID_Atlet
        ) as subquery
    )
    -- Update the ranks in the ATLET table
    UPDATE badudu.ATLET SET World_Rank = ranked.rank
    FROM ranked
    WHERE ATLET.ID = ranked.ID;

    -- Calculate new ranks
    WITH ranked AS (
        SELECT ID, ROW_NUMBER() OVER (ORDER BY sum_points DESC) AS rank
        FROM (
            SELECT ID_Atlet AS ID, SUM(Total_Point) as sum_points
            FROM badudu.POINT_HISTORY
            WHERE Tahun = EXTRACT(YEAR FROM CURRENT_DATE)
            GROUP BY ID_Atlet
        ) as subquery
    )
    UPDATE badudu.ATLET_KUALIFIKASI SET World_Rank = ranked.rank
    FROM ranked
    WHERE ATLET_KUALIFIKASI.ID_Atlet = ranked.ID;

    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER world_rank_update_trigger
AFTER INSERT OR UPDATE ON badudu.POINT_HISTORY
FOR EACH ROW
EXECUTE PROCEDURE update_world_rank();
