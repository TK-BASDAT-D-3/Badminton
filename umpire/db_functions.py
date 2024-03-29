from django.db import connection


def get_all_event_data():
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("SELECT * FROM EVENT")
        rows = cursor.fetchall()
    return rows


def get_event_data(event_name):
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("SELECT * FROM EVENT WHERE Nama_Event = %s", [event_name])
        rows = cursor.fetchone()
    return rows


def get_partai_kompetisi_in_event(event_name):
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            "SELECT * FROM PARTAI_KOMPETISI WHERE Nama_Event = %s", [event_name]
        )
        rows = cursor.fetchall()
    return rows


def add_or_update_point_history(peserta_id, babak, kategori, minggu_ke, bulan, tahun):
    point_map = {
        "Super": {
            "Juara 1": 1000,
            "Juara 2": 800,
            "Semifinal": 600,
            "Perempat final": 400,
            "R16": 200,
            "R32": 100,
        },
        "Series": {
            "Juara 1": 750,
            "Juara 2": 600,
            "Semifinal": 450,
            "Perempat final": 300,
            "R16": 150,
            "R32": 75,
        },
        "S1000": {
            "Juara 1": 1000,
            "Juara 2": 800,
            "Semifinal": 600,
            "Perempat final": 400,
            "R16": 200,
            "R32": 100,
        },
        "S750": {
            "Juara 1": 750,
            "Juara 2": 600,
            "Semifinal": 450,
            "Perempat final": 300,
            "R16": 150,
            "R32": 75,
        },
        "S500": {
            "Juara 1": 500,
            "Juara 2": 400,
            "Semifinal": 300,
            "Perempat final": 200,
            "R16": 100,
            "R32": 50,
        },
        "S300": {
            "Juara 1": 300,
            "Juara 2": 240,
            "Semifinal": 180,
            "Perempat final": 120,
            "R16": 60,
            "R32": 30,
        },
        "S100": {
            "Juara 1": 100,
            "Juara 2": 80,
            "Semifinal": 60,
            "Perempat final": 40,
            "R16": 20,
            "R32": 10,
        },
    }
    point = point_map[kategori][babak]

    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            INSERT INTO point_history (id_atlet, total_point, Minggu_ke, Bulan, tahun)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (id_atlet, Minggu_ke, Bulan, tahun)
            DO UPDATE SET total_point = point_history.total_point + EXCLUDED.total_point
        """,
            [peserta_id, point, minggu_ke, bulan, tahun],
        )


from django.db import connection


def insert_new_match_in_event(
    jenis_babak, tanggal, waktu_mulai, total_durasi, nama_event, tahun_event, id_umpire
):
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        query = """
        INSERT INTO match (jenis_babak, tanggal, waktu_mulai, total_durasi, nama_event, tahun_event, id_umpire) 
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(
            query,
            [
                jenis_babak,
                tanggal,
                waktu_mulai,
                total_durasi,
                nama_event,
                tahun_event,
                id_umpire,
            ],
        )


def insert_into_game(No_Game, Durasi, Jenis_Babak, Tanggal, Waktu_Mulai):
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            INSERT INTO GAME (No_Game, Durasi, Jenis_Babak, Tanggal, Waktu_Mulai)
            VALUES (%s, %s, %s, %s, %s)
            """,
            [No_Game, Durasi, Jenis_Babak, Tanggal, Waktu_Mulai],
        )


def insert_into_peserta_mengikuti_game(Nomor_Peserta, No_Game, Skor):
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            INSERT INTO PESERTA_MENGIKUTI_GAME (Nomor_Peserta, No_Game, Skor)
            VALUES (%s, %s, %s)
            """,
            [Nomor_Peserta, No_Game, Skor],
        )


def insert_peserta_mengikuti_match(
    jenis_babak, tanggal, waktu_mulai, nomor_peserta, status_menang
):
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        sql = """
        INSERT INTO PESERTA_MENGIKUTI_MATCH (Jenis_Babak, Tanggal, Waktu_Mulai, Nomor_Peserta, Status_Menang)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(
            sql, (jenis_babak, tanggal, waktu_mulai, nomor_peserta, status_menang)
        )


def insert_into_peserta_mengikuti_match(
    Jenis_Babak, Tanggal, Waktu_Mulai, Nomor_Peserta, Status_Menang
):
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            INSERT INTO PESERTA_MENGIKUTI_MATCH (Jenis_Babak, Tanggal, Waktu_Mulai, Nomor_Peserta, Status_Menang)
            VALUES (%s, %s, %s, %s, %s)
            """,
            [Jenis_Babak, Tanggal, Waktu_Mulai, Nomor_Peserta, Status_Menang],
        )


def get_nama_from_id_atlet(id_atlet):
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            SELECT nama FROM MEMBER WHERE id = %s
            """,
            [id_atlet],
        )
        return cursor.fetchone()[0]


def get_atlet_ganda(id_atlet_ganda):
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            select * from atlet_ganda where id_atlet_ganda= %s
            """,
            [id_atlet_ganda],
        )
        return cursor.fetchone()


def get_peserta_kompetisi_data(event_name):
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            SELECT * FROM BADUDU.PESERTA_KOMPETISI WHERE nomor_peserta in
                (SELECT nomor_peserta FROM badudu.peserta_mendaftar_event
                WHERE nama_event = %s)
        """,
            [event_name],
        )
        peserta_kompetisi = cursor.fetchall()
        for index, peserta in enumerate(peserta_kompetisi):
            if peserta[1]:
                data_atlet_ganda = get_atlet_ganda(peserta[1])
                data_atlet_1 = get_nama_from_id_atlet(data_atlet_ganda[1])
                data_atlet_2 = get_nama_from_id_atlet(data_atlet_ganda[2])
                peserta_kompetisi[index] = peserta + (
                    data_atlet_1 + " & " + data_atlet_2,
                )
            elif peserta[2]:
                peserta_kompetisi[index] = peserta + (
                    get_nama_from_id_atlet(peserta[2]),
                )

    return {
        "peserta_kompetisi": peserta_kompetisi,
    }


def get_pemenang_data_from_match_id(babak, tanggal, waktu_mulai):
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            select peserta_kompetisi.nomor_peserta, peserta_kompetisi.id_atlet_ganda, peserta_kompetisi.id_atlet_kualifikasi, peserta_kompetisi.world_rank, peserta_kompetisi.world_tour_rank from badudu."match" 
            join badudu.peserta_mengikuti_match ON peserta_mengikuti_match.jenis_babak = "match".jenis_babak and peserta_mengikuti_match.tanggal = "match".tanggal and peserta_mengikuti_match.waktu_mulai = "match".waktu_mulai 
            join badudu.peserta_kompetisi ON peserta_kompetisi.nomor_peserta = peserta_mengikuti_match.nomor_peserta
            where peserta_mengikuti_match.status_menang=true and "match".jenis_babak= %s and "match".tanggal= %s and "match".waktu_mulai= %s
        """,
            [babak, tanggal, waktu_mulai],
        )
        peserta_kompetisi = cursor.fetchall()
        for index, peserta in enumerate(peserta_kompetisi):
            if peserta[1]:
                data_atlet_ganda = get_atlet_ganda(peserta[1])
                data_atlet_1 = get_nama_from_id_atlet(data_atlet_ganda[1])
                data_atlet_2 = get_nama_from_id_atlet(data_atlet_ganda[2])
                peserta_kompetisi[index] = peserta + (
                    data_atlet_1 + " & " + data_atlet_2,
                )
            elif peserta[2]:
                peserta_kompetisi[index] = peserta + (
                    get_nama_from_id_atlet(peserta[2]),
                )

    return {
        "peserta_kompetisi": peserta_kompetisi,
    }

def get_peserta_kalah_data_from_match_id(babak, tanggal, waktu_mulai):
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            select peserta_kompetisi.nomor_peserta, peserta_kompetisi.id_atlet_ganda, peserta_kompetisi.id_atlet_kualifikasi, peserta_kompetisi.world_rank, peserta_kompetisi.world_tour_rank from badudu."match" 
            join badudu.peserta_mengikuti_match ON peserta_mengikuti_match.jenis_babak = "match".jenis_babak and peserta_mengikuti_match.tanggal = "match".tanggal and peserta_mengikuti_match.waktu_mulai = "match".waktu_mulai 
            join badudu.peserta_kompetisi ON peserta_kompetisi.nomor_peserta = peserta_mengikuti_match.nomor_peserta
            where peserta_mengikuti_match.status_menang=false and "match".jenis_babak= %s and "match".tanggal= %s and "match".waktu_mulai= %s
        """,
            [babak, tanggal, waktu_mulai],
        )
        peserta_kompetisi = cursor.fetchall()
        for index, peserta in enumerate(peserta_kompetisi):
            if peserta[1]:
                data_atlet_ganda = get_atlet_ganda(peserta[1])
                data_atlet_1 = get_nama_from_id_atlet(data_atlet_ganda[1])
                data_atlet_2 = get_nama_from_id_atlet(data_atlet_ganda[2])
                peserta_kompetisi[index] = peserta + (
                    data_atlet_1 + " & " + data_atlet_2,
                )
            elif peserta[2]:
                peserta_kompetisi[index] = peserta + (
                    get_nama_from_id_atlet(peserta[2]),
                )

    return {
        "peserta_kompetisi": peserta_kompetisi,
    }

from django.db import connection

def get_member_by_email_and_nama(email, nama):
    with connection.cursor() as cursor:
        cursor.execute("""
            select member.id, 'atlet' from badudu.member join badudu.atlet ON atlet.id = member.id 
            where member.nama=%s and member.email=%s
            union
            select member.id, 'pelatih' from badudu.member join badudu.pelatih ON pelatih.id = member.id
            where member.nama=%s and member.email=%s
            union
            select member.id, 'umpire' from badudu.member join badudu.umpire ON umpire.id = member.id
            where member.nama=%s and member.email=%s
            
        """,
        [nama, email, nama, email, nama, email])
        row = cursor.fetchone()
        return row