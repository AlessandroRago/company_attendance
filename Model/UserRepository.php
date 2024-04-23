<?php

namespace Model;
use Util\Connection;

class UserRepository{

    public static function userAuthentication(string $id, string $password):array|null{
        $pdo = Connection::getInstance();
        $sql = 'SELECT * FROM user WHERE id=:id';
        $stmt = $pdo->prepare($sql);
        $stmt->execute([
                'id' => $id
            ]
        );

        //Non esiste un utente con quell' id nel database
        if($stmt->rowCount() == 0)
            return null;
        //Recupera i dati dell'utente
        $row = $stmt->fetch();
        //Verifica che la password corrisponda
        //Se non corrisponde ritorna null
        if (!password_verify($password, $row['password']))
            return null;
        //Altrimenti ritorna il vettore contenente i dati dell'utente

        return $row;
    }
    public static function AddUser(string $name,string $surname , string $password){
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

}