import uuid
from django.db import connection

def insert_atlet(nama, email,negara,tanggal_lahir,play,tinggi_badan,jenis_kelamin):
    with connection.cursor() as cursor:
        id = uuid.uuid4()
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
            INSERT INTO member (id, nama, email) 
            VALUES (%s, %s, %s)
        """, [id, nama, email])

        cursor.execute("""
            INSERT INTO atlet (id, tgl_lahir, negara_asal, play_right, height, world_rank, jenis_kelamin) 
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, [id, tanggal_lahir, negara, play, tinggi_badan, None, jenis_kelamin])

def insert_pelatih(request, nama, email,negara,tanggal_lahir,play,tinggi_badan,jenis_kelamin):
    pass

def insert_umpire(nama, email, negara):
    with connection.cursor() as cursor:
        id = uuid.uuid4()
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
            INSERT INTO member (id, nama, email) 
            VALUES (%s, %s, %s)
        """, [id, nama, email])

        cursor.execute("""
            INSERT INTO umpire (id, negara) 
            VALUES (%s, %s)
        """, [id, negara])


def get_list_ujian_kualifikasi():
    data = {'ujians':[]}
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute('select * from ujian_kualifikasi')
        ujian_kompetisi = cursor.fetchall()
        for row in ujian_kompetisi:
            data['ujians'].append({
                'tahun': row[0],
                'batch': row[1],
                'tempat': row[2],
                'tanggal': row[3]
            })
            
    return data

def get_all_riwayat_ujian_kualifikasi():
    data = {'riwayats':[]}
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
            select nama, tahun, batch, tempat, tanggal, hasil_lulus
            from atlet_nonkualifikasi_ujian_kualifikasi u 
            join member m on u.id_atlet = m.id
            where hasil_lulus='f'
        """)
        ujian_kompetisi = cursor.fetchall()
        for row in ujian_kompetisi:
            data['riwayats'].append({
                'nama': row[0],
                'tahun': row[1],
                'batch': row[2],
                'tempat': row[3],
                'tanggal': row[4],
                'hasil': row[4]
            })
            
    return data

def get_user_riwayat_ujian_kualifikasi(id):
    data = {'riwayats':[]}
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
            select nama, tahun, batch, tempat, tanggal, hasil_lulus
            from atlet_nonkualifikasi_ujian_kualifikasi u 
            join member m on u.id_atlet = m.id
            where m.id = %s

        """, [id])
        ujian_kompetisi = cursor.fetchall()
        for row in ujian_kompetisi:
            data['riwayats'].append({
                'nama': row[0],
                'tahun': row[1],
                'batch': row[2],
                'tempat': row[3],
                'tanggal': row[4],
                'hasil': row[4]
            })
            
    return data

def insert_ujian_kualifikasi(tahun, batch, tempat, tanggal):
    with connection.cursor() as cursor:
        search_path = "badudu"
        cursor.execute(f"SET search_path TO {search_path}")
        cursor.execute("""
            INSERT INTO ujian_kualifikasi (tahun, batch, tempat, tanggal) 
            VALUES (%s, %s, %s, %s)
        """, [tahun, batch, tempat, tanggal])