from django.db import connection


def get_all_event_data():
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("SELECT * FROM EVENT")
        rows = cursor.fetchall()
    return rows

def get_event_data(event_name):
    with connection.cursor() as cursor:
        # Set the desired search path
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("SELECT * FROM EVENT WHERE Nama_Event = %s", [event_name])
        rows = cursor.fetchone()
    return rows

def get_partai_kompetisi_in_event(event_name):
    with connection.cursor() as cursor:
            # Set the desired search path
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("SELECT * FROM PARTAI_KOMPETISI WHERE Nama_Event = %s", [event_name])
        rows = cursor.fetchall()
    return rows

def update_durasi_in_match(jenis_babak, tanggal, waktu_mulai, new_durasi):
    with connection.cursor() as cursor:
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
            UPDATE MATCH
            SET Total_Durasi = %s
            WHERE Jenis_Babak = %s AND Tanggal = %s AND Waktu_Mulai = %s
        """, [new_durasi, jenis_babak, tanggal, waktu_mulai])



def add_or_update_point_history(peserta_id, babak, kategori, minggu_ke, bulan, tahun):
    point_map = {
        'Super': {'Juara 1': 1000, 'Juara 2': 800, 'Semifinal': 600, 'Perempat final': 400, 'R16': 200, 'R32': 100},
        'Series': {'Juara 1': 750, 'Juara 2': 600, 'Semifinal': 450, 'Perempat final': 300, 'R16': 150, 'R32': 75},
        'S1000': {'Juara 1': 1000, 'Juara 2': 800, 'Semifinal': 600, 'Perempat final': 400, 'R16': 200, 'R32': 100},
        'S750': {'Juara 1': 750, 'Juara 2': 600, 'Semifinal': 450, 'Perempat final': 300, 'R16': 150, 'R32': 75},
        'S500': {'Juara 1': 500, 'Juara 2': 400, 'Semifinal': 300, 'Perempat final': 200, 'R16': 100, 'R32': 50},
        'S300': {'Juara 1': 300, 'Juara 2': 240, 'Semifinal': 180, 'Perempat final': 120, 'R16': 60, 'R32': 30},
        'S100': {'Juara 1': 100, 'Juara 2': 80, 'Semifinal': 60, 'Perempat final': 40, 'R16': 20, 'R32': 10},
    }
    point = point_map[kategori][babak]

    with connection.cursor() as cursor:
            # Set the desired search path
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
            INSERT INTO point_history (id_atlet, total_point, Minggu_ke, Bulan, tahun)
            VALUES (%s, %s, %s, %s, %s)
            ON CONFLICT (id_atlet, Minggu_ke, Bulan, tahun)
            DO UPDATE SET total_point = point_history.total_point + EXCLUDED.total_point
        """, [peserta_id, point, minggu_ke, bulan, tahun])

from django.db import connection


def insert_new_match_in_event(jenis_babak, tanggal, waktu_mulai, total_durasi, nama_event, tahun_event, id_umpire):
    with connection.cursor() as cursor:
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        query = """
        INSERT INTO match (jenis_babak, tanggal, waktu_mulai, total_durasi, nama_event, tahun_event, id_umpire) 
        VALUES (%s, %s, %s, %s, %s, %s, %s)
        """
        cursor.execute(query, [jenis_babak, tanggal, waktu_mulai, total_durasi, nama_event, tahun_event, id_umpire])

def insert_into_game(No_Game, Durasi, Jenis_Babak, Tanggal, Waktu_Mulai):
    with connection.cursor() as cursor:
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            INSERT INTO GAME (No_Game, Durasi, Jenis_Babak, Tanggal, Waktu_Mulai)
            VALUES (%s, %s, %s, %s, %s)
            """,
            [No_Game, Durasi, Jenis_Babak, Tanggal, Waktu_Mulai]
        )

def insert_into_peserta_mengikuti_game(Nomor_Peserta, No_Game, Skor):
    with connection.cursor() as cursor:
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            INSERT INTO PESERTA_MENGIKUTI_GAME (Nomor_Peserta, No_Game, Skor)
            VALUES (%s, %s, %s)
            """,
            [Nomor_Peserta, No_Game, Skor]
        )


def insert_peserta_mengikuti_match(jenis_babak, tanggal, waktu_mulai, nomor_peserta, status_menang):
    with connection.cursor() as cursor:
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        sql = """
        INSERT INTO PESERTA_MENGIKUTI_MATCH (Jenis_Babak, Tanggal, Waktu_Mulai, Nomor_Peserta, Status_Menang)
        VALUES (%s, %s, %s, %s, %s)
        """
        cursor.execute(sql, (jenis_babak, tanggal, waktu_mulai, nomor_peserta, status_menang))


def insert_into_peserta_mengikuti_match(Jenis_Babak, Tanggal, Waktu_Mulai, Nomor_Peserta, Status_Menang):
    with connection.cursor() as cursor:
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            INSERT INTO PESERTA_MENGIKUTI_MATCH (Jenis_Babak, Tanggal, Waktu_Mulai, Nomor_Peserta, Status_Menang)
            VALUES (%s, %s, %s, %s, %s)
            """,
            [Jenis_Babak, Tanggal, Waktu_Mulai, Nomor_Peserta, Status_Menang]
        )

def get_nama_from_id_atlet(id_atlet):
    with connection.cursor() as cursor:
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            SELECT nama FROM MEMBER WHERE id = %s
            """,
            [id_atlet]
        )
        return cursor.fetchone()[0]
    
def get_atlet_ganda(id_atlet_ganda):
    with connection.cursor() as cursor:
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute(
            """
            select * from atlet_ganda where id_atlet_ganda= %s
            """,
            [id_atlet_ganda]
        )
        return cursor.fetchone()
    
def get_peserta_kompetisi_data(event_name):
    with connection.cursor() as cursor:
            # Set the desired search path
        search_path = 'badudu'
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
            SELECT * FROM BADUDU.PESERTA_KOMPETISI WHERE nomor_peserta in
                (SELECT nomor_peserta FROM badudu.peserta_mendaftar_event
                WHERE nama_event = %s)
        """, [event_name])
        peserta_kompetisi = cursor.fetchall()
        print(peserta_kompetisi)
        atlet_ganda_data = []
        atlet_kualifikasi_data = []
        map_id_to_nama = {}
        for index, peserta in enumerate(peserta_kompetisi):
            if peserta[1]:
                data_atlet_ganda = get_atlet_ganda(peserta[1])
                data_atlet_1 = get_nama_from_id_atlet(data_atlet_ganda[1])
                data_atlet_2 = get_nama_from_id_atlet(data_atlet_ganda[2])
                peserta_kompetisi[index] = peserta + (data_atlet_1 + ' & ' + data_atlet_2, )
                atlet_ganda_data.append(peserta_kompetisi[index])
            elif peserta[2]:
                peserta_kompetisi[index] = peserta + (get_nama_from_id_atlet(peserta[2]), )
                atlet_kualifikasi_data.append(peserta_kompetisi[index])

    
    return {
        'peserta_kompetisi': peserta_kompetisi,
        'atlet_ganda_data': atlet_ganda_data,
        'atlet_kualifikasi_data': atlet_kualifikasi_data,
        'map_id_to_nama': map_id_to_nama
    }