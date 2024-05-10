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
        var_dump($password);

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
        $sql = 'SELECT id FROM company_att.user WHERE name = :name AND password = :password ';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
                'name' => $name,
                'password' => $password,
            ]
        );
        return $stmt->fetchAll();
    }


}