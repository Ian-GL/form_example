import { validate_form, get_country_list } from "../../shared_gleam/build/dev/javascript/shared_gleam/shared_gleam.mjs"

const validateForm = () => {
  const form = document.getElementById("form");
  const formData = new FormData(form)
  const formObj = Object.fromEntries(formData);

  let res = validate_form(formObj)

  let countryList = get_country_list()
  console.log(countryList)


  console.log("RES")
  console.log(res)
}

const button = document.getElementById("formButton");
button.addEventListener("click", validateForm);

export default validateForm