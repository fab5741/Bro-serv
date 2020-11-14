$( document ).ready(function() {
    $('#closeHead').click(function() {
        $('#head').hide();
        fetch(`https://skinManager/close`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
        })
    })    
});

window.addEventListener('message', (event) => {
    if (event.data.type === 'open') {
        $('#head').show();
    }
    $(document).on('input change', '#sex', function() {
        fetch(`https://skinManager/sexe`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });
    $(document).on('input change', '#face', function() {
        fetch(`https://skinManager/face`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });
    $(document).on('input change', '#hair_color_1', function() {
        fetch(`https://skinManager/hair_color_1`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });
    $(document).on('input change', '#hair_color_2', function() {
        fetch(`https://skinManager/hair_color_2`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });
    $(document).on('input change', '#torso_1', function() {
        fetch(`https://skinManager/torso_1`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });
    $(document).on('input change', '#torso_2', function() {
        fetch(`https://skinManager/torso_2`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });
    $(document).on('input change', '#tshirt_1', function() {
        fetch(`https://skinManager/tshirt_1`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });
    $(document).on('input change', '#tshirt_2', function() {
        fetch(`https://skinManager/tshirt_2`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });
    $(document).on('input change', '#pants_1', function() {
        fetch(`https://skinManager/pants_1`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });
    $(document).on('input change', '#pants_2', function() {
        fetch(`https://skinManager/pants_2`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });

    $(document).on('input change', '#shoes_1', function() {
        fetch(`https://skinManager/shoes_1`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });
    $(document).on('input change', '#shoes_2', function() {
        fetch(`https://skinManager/shoes_2`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json; charset=UTF-8',
            },
            body: JSON.stringify(
                $(this).val()
            )
        })
    });
});