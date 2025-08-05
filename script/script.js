<script>
$(window).load(
    function(){  
        if (!sessionStorage.getItem('logado'))
        {
            $('#myModal').modal('show');
        } 
        else
        {
            $('#myModal').modal('hide'); 
        }
    }
);
var timeInMs = Date.now();
var today = new Date(timeInMs);
let senhaO = today.getDate();
var senhaC = document.getElementById('senhaC');

function validarSenha() {
    if(senhaO != senhaC.value)
    {
        senhaC.setCustomValidity("Favor digitar a senha correta!");
        senhaC.reportValidity();
        return false;
    }
    else
    {
        senhaC.setCustomValidity("");
        sessionStorage.setItem('logado', 'true');
        $('#myModal').modal('hide');
        return true;
    }
}
// Logout
function logout() {
    sessionStorage.removeItem('logado');
    location.reload();
}
</script>
