import { HttpClient } from '@angular/common/http';
import { Injectable } from '@angular/core';
import { Observable } from 'rxjs';
import { environment } from './../../environments/environment';
import { Fruit } from './fruit';

@Injectable({
  providedIn: 'root'
})
export class FruitService {

  constructor(private http: HttpClient) { }

  list(): Observable<Fruit[]> {
    const url = `${environment.apiUrl}/fruits`;
    return this.http.get<Fruit[]>(url);
  }

  create(fruit: Fruit): Observable<Fruit> {
    const url = `${environment.apiUrl}/fruits`;
    return this.http.post<Fruit>(url, fruit);
  }

  update(fruit: Fruit): Observable<Fruit> {
    const url = `${environment.apiUrl}/fruits/${fruit.id}`;
    return this.http.put<Fruit>(url, fruit);
  }

  delete(fruit: Fruit): Observable<any> {
    const url = `${environment.apiUrl}/fruits/${fruit.id}`;
    return this.http.delete<any>(url);
  }


}
