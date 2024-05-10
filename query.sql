-- Query per vedere le ore fatte in una giornata di lavoro di un dipendente

SELECT SEC_TO_TIME(SUM(time)) as time FROM (SELECT TIME_TO_SEC(TIMEDIFF(`exit`.time,entrance.time)) as time
                                            FROM worktime
                                                     INNER JOIN `exit` ON `exit`.id = worktime.id_exit
                                                     INNER JOIN entrance ON entrance.id = worktime.id_entrance
                                            WHERE worktime.id_workshift = 1) as a;

-- Query per vedere tutte le ore fatte  di un dipendente
SELECT SEC_TO_TIME(SUM(time)) as time FROM (SELECT TIME_TO_SEC(TIMEDIFF(`exit`.time,entrance.time)) as time
                                            FROM worktime
                                                     INNER JOIN `exit` ON `exit`.id = worktime.id_exit
                                                     INNER JOIN entrance ON entrance.id = worktime.id_entrance
                                                     INNER JOIN workshift ON worktime.id_workshift = workshift.id
                                            WHERE workshift.id_user = 19) as a;

-- Previsione stipendio di un dipendente

SELECT (SUM(time)*(SELECT user.hourly_rate FROM user WHERE id = 19)/3600) as stipendio_euro FROM (SELECT TIME_TO_SEC(TIMEDIFF(`exit`.time,entrance.time)) as time
                                                                                                  FROM worktime
                                                                                                           INNER JOIN `exit` ON `exit`.id = worktime.id_exit
                                                                                                           INNER JOIN entrance ON entrance.id = worktime.id_entrance
                                                                                                           INNER JOIN workshift ON worktime.id_workshift = workshift.id
                                                                                                  WHERE workshift.id_user = 19) as a;