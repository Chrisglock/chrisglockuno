// Initialize variables
let products = [];
let total = 0;
const productList = document.getElementById('product-list');
const totalPrice = document.getElementById('total-price');

// Add event listener to the form submission
document.getElementById('add-product-form').addEventListener('submit', function(event) {
  event.preventDefault();
  const name = document.getElementById('product-name').value.trim();
  var price = parseFloat(document.getElementById('product-price').value.trim());
  const cantidad = parseInt(document.getElementById('cant-price').value.trim());

  if (name !== '' && !isNaN(price)) {
    // Add new product to the array
    products.push({name: name, price: price,cantidad:cantidad, completed: false});

    // Render the updated product list
    renderProducts();

    // Reset the form
    document.getElementById('add-product-form').reset();
  }
});

// Add event listener to the product list to handle editing and deleting
productList.addEventListener('click', function(event) {

  if (event.target.matches('.productInput')) {

    const index = parseInt(event.target.dataset.index);
    const product = products[index];
    console.log(index)
    // Toggle the completed status of the product
    //product.completed = !product.completed;

    // Update the total price
    total += product.price*product.cantidad;
    totalPrice.textContent = "$ "+ total.toFixed(2);
    
  } else if (event.target.matches('.delete-btn')) {
    // Delete button clicked
    // Update the total price
    const index = parseInt(event.target.dataset.index);
    total +=products[index].completed ? -products[index].price*product.cantidad : 0;
    totalPrice.textContent ="$ "+  total.toFixed(2);
    products.splice(index, 1);
    renderProducts();
  }

});

// Render the product list
// Render the product list
function renderProducts() {
    // Clear the previous product list
    productList.innerHTML = '';
  
    // Render each product
    products.forEach(function(product, index) {
      // Create a new table row for the product
      const row = document.createElement('tr');
  
      // Add the product name
      const nameCell = document.createElement('td');
      var nameCellinput = document.createElement('input');
      nameCellinput.classList.add('form-control');
      nameCellinput.value = product.name;
      nameCell.appendChild(nameCellinput);
      row.appendChild(nameCell);
      
      // Add the product quantity
      const cantCell = document.createElement('td');//create the column
      var cantCellinput = document.createElement('input');//create input cell
      cantCellinput.classList.add('form-control','productInput');//add class
      cantCell.setAttribute('data-index', index);
      cantCellinput.value = product.cantidad;//add value to the input
      cantCell.appendChild(cantCellinput);//add the input elemnt to the columg
      row.appendChild(cantCell); //add the column to the row
      
      // Add the product price
      const priceCell = document.createElement('td');
      const cashSign = document.createElement('label');
      priceCell.setAttribute('data-index', index);
      cashSign.textContent = "$";
      priceCell.setAttribute('id', 'pricetd');
      priceCell.appendChild(cashSign);
      
      //priceCell.textContent = "$";
      var priceCellinput = document.createElement('input');//create input cell
      priceCellinput.classList.add('form-control','productInput');//add class
      priceCellinput.value = product.price;//add value to the input
      priceCell.appendChild(priceCellinput);//add the input elemnt to the columg
      row.appendChild(priceCell);
  
      // Add the edit button
      const editCell = document.createElement('td');
      const editButton = document.createElement('button');
      editButton.classList.add('btn', 'btn-secondary', 'edit-btn');
      editButton.textContent = 'Editar';
      editButton.setAttribute('data-index', index);
      //editCell.appendChild(editButton);
      //row.appendChild(editCell);
  
      // Add the delete button
      //const deleteCell = document.createElement('td');
      const deleteButton = document.createElement('button');
      deleteButton.classList.add('btn', 'btn-danger', 'delete-btn');
      deleteButton.textContent = 'Borrar';
      deleteButton.setAttribute('data-index', index);
      editCell.appendChild(deleteButton);
      //row.appendChild(editCell);
  
      // Add the completed checkbox
      //const completedCell = document.createElement('td');
      const completedCheckbox = document.createElement('input');
      completedCheckbox.setAttribute('type', 'checkbox');
      completedCheckbox.setAttribute('id', 'checkbox'+String(index));
      completedCheckbox.classList.add('completed-checkbox');
      completedCheckbox.checked = product.completed;
      completedCheckbox.setAttribute('data-index', index);
      editCell.appendChild(completedCheckbox);
      row.appendChild(editCell);//agregar el borrar y el checkbox al row
  
      // Cross out the product name and price if completed
      if (product.completed) {
        nameCell.classList.add('completed');
        priceCell.classList.add('completed');
        cantCell.classList.add('completed');
      }
  
      // Add the row to the product list
      productList.appendChild(row);
    });
  }
  