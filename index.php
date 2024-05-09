<?php

require_once 'vendor/autoload.php';
require_once 'conf/config.php';

use League\Plates\Engine;
use Util\Authenticator;

function page_refresh(){
    echo "<meta http-equiv='refresh' content='0;url=index.php'>";
    exit;
}


$template = new Engine('templates','tpl');

//Fa partire il processo di autenticazione

//var_dump($user);





if (isset($_GET['action'])){
    if (($_GET['action']) == 'logout'){
        Authenticator::logout();
        echo $template->render('login');
        exit(0);
    }
    if (($_GET['action']) == 'new_user'){
        $name = $_POST['firstName'];
        $surname = $_POST['lastName'];
        \Model\UserRepository::AddUser($name,$surname);
        echo $template->render('login');
        page_refresh();
        exit(0);
    }
    if (($_GET['action']) == 'generator'){
        $password = \Model\UserRepository::GeneratePsw();
        echo $template->render('generator', [
            'password' => $password
            ]
        );
        exit(0);
    }
    if (($_GET['action']) == 'Authorization'){
        $user = Authenticator::getUser();
        if ($user != null) {
            echo "Funziona";
            echo $template->render('index', [
                'user' => $user
            ]);
        }
    }
}

echo $template->render('login', [
]);