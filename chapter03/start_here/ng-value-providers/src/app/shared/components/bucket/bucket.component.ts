import { Component, Inject, inject, OnInit } from '@angular/core';
import { Observable } from 'rxjs/internal/Observable';
import { BucketService } from 'src/app/services/bucket.service';
import { Fruit } from '../../../constants/fruit';
import { IFruit } from '../../../interfaces/fruit.interface';
import { APP_CONFIG, IAppConfig } from 'src/app/constants/app-config';

@Component({
  selector: 'app-bucket',
  templateUrl: './bucket.component.html',
  styleUrls: ['./bucket.component.scss']
})
export class BucketComponent implements OnInit {
  $bucket: Observable<IFruit[]>;
  selectedFruit: Fruit = '' as null;
  fruits: string[] = Object.values(Fruit);
  constructor(
    private bucketService: BucketService,
    @Inject(APP_CONFIG) private appConfig: IAppConfig)
    { }

  canDeleteItems(): boolean {
    return this.appConfig.canDeleteItems;
  }

  ngOnInit(): void {
    this.$bucket = this.bucketService.$bucket;
    this.bucketService.loadItems();
  }

  addSelectedFruitToBucket() {
    this.bucketService.addItem({
      id: Date.now(),
      name: this.selectedFruit
    })
  }
  deleteFromBucket(fruit: IFruit) {
    this.bucketService.removeItem(fruit);
  }

}
