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
    public static function AddUser(string $name,string $surname): bool
    {
        $password = $_POST['password'];
        $pdo = Connection::getInstance();
        $sql = 'INSERT INTO user (name, surname, password) VALUES (:name, :surname, :password);';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
                'name' => $name,
                'surname' => $surname,
                'password' => hash('sha256',$password)

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
    public static function getId(string $name, string $password): int{
        $pdo = Connection::getInstance();
        $sql = 'SELECT id FROM company_attendance.user WHERE name = :name AND password = :password ';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
                'name' => $name,
                'password' => $password,
            ]
        );
        return $stmt->fetchAll();
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
        if ($row['exit_id'] != null) {

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
SELECT exit_id
FROM worktime
INNER JOIN workshift ON worktime.workshift_id = workshift.id
WHERE workshift.date = CURDATE() AND
((SELECT MAX(a.entrance_id) FROM (SELECT entrance_id FROM worktime
INNER JOIN workshift ON worktime.workshift_id = workshift.id
WHERE workshift_id = (SELECT id FROM workshift WHERE user_id = :id)) as a) = entrance_id);';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
                'id' => $user['id']
            ]
        );
        $row = $stmt->fetch();
        if ($row['exit_id'] == null) {

            $sql = 'INSERT INTO company_attendance.exit (time,user_id,justification_id) VALUES (:time, :user_id,1);';
            $stmt = $pdo->prepare($sql);
            $stmt->execute([
                    'time' => date('H:i:s'),
                    'user_id' => $user['id'],
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
}