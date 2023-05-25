# This is an auto-generated Django model module.
# You'll have to do the following manually to clean this up:
#   * Rearrange models' order
#   * Make sure each model has one field with primary_key=True
#   * Make sure each ForeignKey and OneToOneField has `on_delete` set to the desired behavior
#   * Remove `managed = False` lines if you wish to allow Django to create, modify, and delete the table
# Feel free to rename the models, but don't rename db_table values or field names.
from django.db import models

class Member(models.Model):
    id = models.UUIDField(primary_key=True)
    nama = models.CharField(max_length=50)
    email = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'member'

class Atlet(models.Model):
    id = models.OneToOneField('Member', models.DO_NOTHING, db_column='id', primary_key=True)
    tgl_lahir = models.DateField()
    negara_asal = models.CharField(max_length=50)
    play_right = models.BooleanField()
    height = models.IntegerField()
    world_rank = models.IntegerField(blank=True, null=True)
    jenis_kelamin = models.BooleanField()

    class Meta:
        managed = False
        db_table = 'atlet'


class Pelatih(models.Model):
    id = models.OneToOneField(Member, models.DO_NOTHING, db_column='id', primary_key=True)
    tanggal_mulai = models.DateField()

    class Meta:
        managed = False
        db_table = 'pelatih'


class Umpire(models.Model):
    id = models.OneToOneField(Member, models.DO_NOTHING, db_column='id', primary_key=True)
    negara = models.CharField(max_length=50)

    class Meta:
        managed = False
        db_table = 'umpire'
