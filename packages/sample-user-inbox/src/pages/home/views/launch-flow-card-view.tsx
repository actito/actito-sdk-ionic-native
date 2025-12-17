import { IonCard, IonIcon, IonItem, IonLabel, IonText } from '@ionic/react';
import { Actito } from 'capacitor-actito';
import { informationCircleOutline } from 'ionicons/icons';
import type { FC } from 'react';
import '../../../styles/index.css';

import { useAlertDialogContext } from '../../../contexts/alert-dialog';
import { useToastContext } from '../../../contexts/toast';

type LaunchFlowCardProps = {
  isReady: boolean;
};

export const LaunchFlowCardView: FC<LaunchFlowCardProps> = ({ isReady }) => {
  const { setCurrentAlertDialog } = useAlertDialogContext();
  const { addToastInfoMessage } = useToastContext();

  async function launchActito() {
    try {
      console.log('=== Launching Actito ===');
      await Actito.launch();

      console.log('=== Launching Actito finished ===');
    } catch (e) {
      console.log('=== Error launching Actito ===');
      console.log(JSON.stringify(e));

      addToastInfoMessage({
        message: 'Error launching Actito.',
        type: 'error',
      });
    }
  }

  async function unlaunchActito() {
    try {
      console.log('=== Unlaunching Actito ===');
      await Actito.unlaunch();

      console.log('=== Unlaunching Actito finished ===');
    } catch (e) {
      console.log('=== Error unlaunching Actito ===');
      console.log(JSON.stringify(e));

      addToastInfoMessage({
        message: 'Error unlaunching Actito.',
        type: 'error',
      });
    }
  }

  async function showActitoStatusInfo() {
    try {
      const isConfiguredStatus = await Actito.isConfigured();
      const isReadyStatus = await Actito.isReady();
      const infoMessage = `isConfigured: ${isConfiguredStatus} <br> isReady: ${isReadyStatus}`;

      setCurrentAlertDialog({ title: 'Actito Status', message: infoMessage });
    } catch (e) {
      console.log('=== Error getting isConfigured / isReady  ===');
      console.log(JSON.stringify(e));
    }
  }

  return (
    <>
      <div className="section-title-row">
        <IonText className="section-title">Launch Flow</IonText>

        <button className="info-button" onClick={showActitoStatusInfo}>
          <IonIcon icon={informationCircleOutline} size="small" />
        </button>
      </div>

      <IonCard className="ion-card-margin">
        <div className="launch-flow-row">
          <IonItem
            className="sample-button"
            detail={false}
            lines="none"
            disabled={isReady}
            button
            onClick={launchActito}
          >
            <IonLabel>Launch</IonLabel>
          </IonItem>

          <div className="divider-vertical"></div>

          <IonItem
            className="sample-button"
            detail={false}
            lines="none"
            disabled={!isReady}
            button
            onClick={unlaunchActito}
          >
            <IonLabel>Unlaunch</IonLabel>
          </IonItem>
        </div>
      </IonCard>
    </>
  );
};
