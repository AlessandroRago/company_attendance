<?php

namespace Model;
use Util\Connection;

class UserRepository{

    public static function userAuthentication(string $password):array|null{
        $pdo = Connection::getInstance();
        $sql = 'SELECT * FROM user WHERE password=:password;';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
                'password' => hash('sha256',$password)
            ]
        );
        //Non esiste un utente con quell' id nel database
        if($stmt->rowCount() == 0)
            return null;
        //Recupera i dati dell'utente
        return $stmt->fetch();
    }
    public static function AddUser(string $name,string $surname, $hourlyWage): bool
    {
        $password = $_POST['password'];
        $pdo = Connection::getInstance();
        $sql = 'INSERT INTO user (name, surname, password, hourly_rate) VALUES (:name, :surname, :password, :hourly_rate);';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
                'name' => $name,
                'surname' => $surname,
                'password' => hash('sha256',$password),
                'hourly_rate' => $hourlyWage

            ]
        );
        return true;
    }

    public static function GeneratePsw(): string
    {
        $data = '1234567890ABCDEFGHIJKLMNOPQRSTUVWXYZabcefghijklmnopqrstuvwxyz';
        $password =  substr(str_shuffle($data), 0, 15);
        $pdo = Connection::getInstance();
        $sql = 'SELECT password FROM user WHERE password=:password;';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
                'password' => hash('sha256',$password)
            ]
        );
        if($stmt->rowCount() == 0) {
            return  $password;
        }
        else {
            return self::GeneratePsw();
        }
    }

    public static function AddImmobile(): bool
    {
        $name = "Ciro";
        $surname = "Immobile";
        $password = self::GeneratePsw();
        $pdo = Connection::getInstance();
        $sql = 'INSERT INTO user (name, surname, password) VALUES (:name, :surname, :password);';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
                'name' => $name,
                'surname' => $surname,
                'password' => $password

            ]
        );
        return true;
    }

    public static function enter($user)
    {
        $pdo = Connection::getInstance();
        $sql = '
SELECT exit_id
FROM worktime
INNER JOIN workshift ON worktime.workshift_id = workshift.id
WHERE workshift.date = CURDATE() AND
((SELECT MAX(a.entrance_id) FROM (SELECT entrance_id FROM worktime
INNER JOIN workshift ON worktime.workshift_id = workshift.id
WHERE workshift_id = (SELECT id 
                      FROM workshift 
                      WHERE user_id = :id AND workshift.date = CURRENT_DATE)) as a) = entrance_id);';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
                'id' => $user['id']
            ]
        );
        $row = $stmt->fetch();
        var_dump($row);
        if ($row['exit_id'] != null || !$row) {

            $sql = 'INSERT INTO entrance (time,user_id) VALUES (:time, :user_id);';
            $stmt = $pdo->prepare($sql);
            $stmt->execute([
                    'time' => date('H:i:s'),
                    'user_id' => $user['id'],
                ]
            );
            $sql = 'INSERT INTO worktime (entrance_id,workshift_id) 
VALUES ((SELECT MAX(id) 
         FROM entrance
         WHERE user_id = :user_id),
        (SELECT id 
         FROM workshift 
         WHERE workshift.date = CURRENT_DATE() AND user_id = :user_id));';
            $stmt = $pdo->prepare($sql);
            $stmt->execute([
                    'user_id' => $user['id'],
                ]
            );
            return true;
        }
        else {
            return false;
        }
    }
    public static function exit($user)
    {
        $pdo = Connection::getInstance();
        $sql = '
SELECT exit_id, worktime.id
FROM worktime
INNER JOIN workshift ON worktime.workshift_id = workshift.id
WHERE workshift.date = CURDATE() AND
((SELECT MAX(a.entrance_id) FROM (SELECT entrance_id FROM worktime
INNER JOIN workshift ON worktime.workshift_id = workshift.id
WHERE workshift_id = (SELECT id FROM workshift WHERE user_id = :id AND  workshift.date = CURRENT_DATE())) as a) = entrance_id);';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
                'id' => $user['id']
            ]
        );
        $row = $stmt->fetch();
        if ($row['exit_id'] == null and $row['id'] != null) {

            $sql = 'INSERT INTO company_attendance.exit (time,user_id,justification_id) VALUES (:time, :user_id,:justification);';
            $stmt = $pdo->prepare($sql);
            $stmt->execute([
                    'time' => date('H:i:s'),
                    'user_id' => $user['id'],
                    'justification' => $_POST['justification']
                ]
            );
            $sql = 'UPDATE worktime 
SET exit_id = ((SELECT MAX(id) 
FROM company_attendance.exit 
WHERE user_id = :user_id))
WHERE workshift_id = (SELECT id 
                      FROM workshift
                      WHERE user_id = :user_id AND workshift.date = CURRENT_DATE())
AND entrance_id = (SELECT MAX(id) 
         FROM entrance
         WHERE user_id = :user_id);';
            $stmt = $pdo->prepare($sql);
            $stmt->execute([
                    'user_id' => $user['id'],
                ]
            );
            return true;
        }
        else {
            return false;
        }

    }
    public static function dailyRoutine()
    {

        $pdo = Connection::getInstance();
        $sql = 'SELECT id FROM user';
        $stmt = $pdo->query($sql);
        $all_id = $stmt ->fetchAll();
        foreach ($all_id as $id) {
            $insert = 'INSERT INTO workshift (date,user_id)
SELECT CURRENT_DATE, :user_id
WHERE NOT EXISTS (SELECT * FROM workshift WHERE date = CURRENT_DATE AND user_id = :user_id)';
            $stmt = $pdo->prepare($insert);
            $stmt->execute([
                    'user_id' => $id['id']
                ]
            );
        }
        $justifications = self::getJustifications();
        echo '<select id="justificationSelect" hidden="hidden">';
        foreach ($justifications as $justification) {
            echo '<option value="'.$justification['id'].'">'.$justification['description'].'</option>';
        }
        echo '</select>';
        return true;
    }
    public static function getJustifications(): array{
        $pdo = Connection::getInstance();
        $sql = 'SELECT * FROM justifications';
        $stmt = $pdo->query($sql);
        return $stmt->fetchAll();
    }

}