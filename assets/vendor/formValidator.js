import { validate_form, get_country_list } from "../../shared_gleam/build/dev/javascript/shared_gleam/shared_gleam.mjs"

const countryList = get_country_list()

const infoAlert = document.getElementById("infoAlert");
const errorAlert = document.getElementById("errorAlert");

const validateForm = () => {
  const form = document.getElementById("form");
  const formData = new FormData(form)
  const formObj = Object.fromEntries(formData);

  let res = validate_form(formObj)
  if(!res.isOk()) {
    showError("Error: " + res[0])
    return
  }

  let csrfToken = document.querySelector("meta[name='csrf-token']").getAttribute("content")

  const req = new XMLHttpRequest();

  req.onreadystatechange = () => {
    if (req.readyState === 4) {
      if (req.status == 200) {
        showInfo("User created successfully")
      } else {
        let errRes = JSON.parse(req.response)
        showError("Error: " + errRes.error)
      }
    }
  }

  req.open("POST", "http://localhost:4000/user")
  req.setRequestHeader("x-csrf-token", csrfToken)
  req.setRequestHeader("content-type", "application/json")
  req.send(JSON.stringify(formObj))
}

const showInfo = (msg) => {
  infoAlert.innerHTML = msg;
}

const showError = (msg) => {
  errorAlert.innerHTML = msg;
}

const select = document.getElementById("countrySelect");
countryList.forEach((country) => {
  let option = document.createElement('option');
  option.value = country.code
  option.innerHTML = country.name
  select.appendChild(option);
})

const button = document.getElementById("formButton");
button.addEventListener("click", validateForm);

export default validateForm