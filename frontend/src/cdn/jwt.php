<?php
function base64url_encode($data) {
    return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
}

function base64url_decode($data) {
    return base64_decode(strtr($data, '-_', '+/'));
}

function jwt_encode($payload, $secret) {
    $header = ['alg'=>'HS256','typ'=>'JWT'];
    $segments = [
        base64url_encode(json_encode($header)),
        base64url_encode(json_encode($payload))
    ];
    $signing = hash_hmac('sha256', implode('.', $segments), $secret, true);
    $segments[] = base64url_encode($signing);
    return implode('.', $segments);
}

function jwt_decode($jwt, $secret) {
    [$h,$p,$s] = explode('.', $jwt);
    $valid = hash_hmac('sha256', "$h.$p", $secret, true);
    if (!hash_equals($valid, base64url_decode($s))) return false;
    return json_decode(base64url_decode($p), true);
}