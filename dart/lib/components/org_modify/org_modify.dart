library org_modify_comp;

import 'package:pritunl/bases/modal_content/modal_content.dart' as
  modal_content;
import 'package:pritunl/models/organization.dart' as organization;
import 'package:pritunl/alert.dart' as alrt;
import 'package:pritunl/logger.dart' as logger;

import 'package:angular/angular.dart' show Component, NgOneWayOneTime;
import 'dart:async' as async;

@Component(
  selector: 'org-modify',
  templateUrl: 'packages/pritunl/components/org_modify/org_modify.html'
)
class ModifyOrgComp extends modal_content.ModalContent {
  organization.Organization model;

  @NgOneWayOneTime('model')
  organization.Organization origModel;

  void show() {
    this.model = this.origModel.clone();
  }

  async.Future submit(async.Future closeHandler()) {
    var valid = this.validateForms({
      'name': '.name',
    });

    if (valid != true) {
      return null;
    }
    this.okDisabled = true;

    return this.model.save(['name']).then((_) {
      return super.submit(closeHandler);
    }).then((_) {
      new alrt.Alert('Successfully modified organization.', 'success');
    }).catchError((err) {
      logger.severe('Failed to modify organization', err);
      this.setAlert('Failed to modify organization, server error occurred.',
        'danger');
    }).whenComplete(() {
      this.okDisabled = false;
    });
  }
}
