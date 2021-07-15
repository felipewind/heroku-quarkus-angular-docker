import { TitleCasePipe } from '@angular/common';
import { Component, OnInit } from '@angular/core';
import { FormBuilder, FormGroup, FormGroupDirective, Validators } from '@angular/forms';
import { Fruit } from './fruit';
import { FruitService } from './fruit.service';

@Component({
  selector: 'app-fruit',
  templateUrl: './fruit.component.html',
  styleUrls: ['./fruit.component.css'],
  providers: [TitleCasePipe]
})
export class FruitComponent implements OnInit {

  fruits: Fruit[] = [];
  displayedColumns: string[] = ['id', 'name', 'action'];
  fruitForm!: FormGroup;
  isEditingFruit: boolean = false;
  editingFruit!: Fruit;

  constructor(
    private fruitService: FruitService,
    private formBuilder: FormBuilder,
    private titlecasePipe: TitleCasePipe) { }

  ngOnInit(): void {
    this.list();
    this.fruitForm = this.formBuilder.group({
      name: [
        '',
        [Validators.required, Validators.minLength(3)],
        ''
      ]
    });
  }

  list(): void {
    this.fruitService.list().subscribe(fruits => this.fruits = fruits);
  }

  create(formDirective: FormGroupDirective): void {
    const fruit: Fruit = this.fruitForm.getRawValue() as Fruit;
    fruit.name = this.titlecasePipe.transform(fruit.name);
    this.fruitService.create(fruit).subscribe(fruit => this.list());
    formDirective.resetForm();
    this.fruitForm.reset();    
  }

  update(): void {
    this.editingFruit.name = this.titlecasePipe.transform(this.fruitForm.get('name')?.value);
    this.fruitService.update(this.editingFruit).subscribe(fruit => this.list());
    this.isEditingFruit = false;
    this.fruitForm.reset();
  }

  edit(fruit: Fruit): void {
    this.isEditingFruit = true;
    this.editingFruit = fruit;
    this.fruitForm.setValue({ name: this.editingFruit.name });
  }

  cancelEdit(): void {
    this.isEditingFruit = false;
    this.fruitForm.reset();
  }

  delete(fruit: Fruit): void {
    this.fruitService.delete(fruit).subscribe(fruit => this.list());
  }

  getErrorMessage(field: string): string {
    if (this.fruitForm.get(field)?.hasError('required')) {
      return `Required`;
    }

    if (this.fruitForm.get(field)?.hasError('minlength')) {
      return `Minum length should be ${this.fruitForm.get(field)?.errors?.minlength.requiredLength}`;
    }

    return this.fruitForm.get(field)?.invalid ? `Not a valid ${field}` : '';

  }


}
