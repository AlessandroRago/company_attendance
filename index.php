<?php

require_once 'vendor/autoload.php';
require_once 'conf/config.php';

use League\Plates\Engine;
use Util\Authenticator;

function page_refresh($mode){
    echo "<meta http-equiv='refresh' content='0;url=index.php?mode=".$mode."'>";
    exit;
}

\Model\UserRepository::dailyRoutine();
$template = new Engine('templates','tpl');
$mode = 'enter';


if(isset($_GET['mode'])) {
    if (($_GET['mode']) == 'exit'){
        $mode = 'exit';
    }
    if (($_GET['mode']) == 'enter'){
        $mode = 'enter';
    }
}

//Fa partire il processo di autenticazione

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
        page_refresh($mode);
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
        \Model\UserRepository::AddImmobile();
        if ($user != null) {

            if (($_GET['mode']) == 'exit'){
                \Model\UserRepository::exit($user);

            }
            if (($_GET['mode']) == 'enter'){
                \Model\UserRepository::enter($user);
            }
            page_refresh($mode);
        }

    }
}


echo $template->render('login', [
    'mode' => $mode
]);