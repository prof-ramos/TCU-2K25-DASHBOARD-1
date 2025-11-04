
import React, { useEffect, useState } from 'react';

interface CountdownProps {
  dataProva: string;
}

const Countdown: React.FC<CountdownProps> = ({ dataProva }) => {
  const [timeLeft, setTimeLeft] = useState({
    days: 0,
    hours: 0,
    minutes: 0,
    seconds: 0
  });

  useEffect(() => {
    const calculateTimeLeft = () => {
      const difference = +new Date(dataProva) - +new Date();
      let timeLeft = { days: 0, hours: 0, minutes: 0, seconds: 0 };

      if (difference > 0) {
        timeLeft = {
          days: Math.floor(difference / (1000 * 60 * 60 * 24)),
          hours: Math.floor((difference / (1000 * 60 * 60)) % 24),
          minutes: Math.floor((difference / 1000 / 60) % 60),
          seconds: Math.floor((difference / 1000) % 60)
        };
      }
      return timeLeft;
    };

    const timer = setInterval(() => {
      setTimeLeft(calculateTimeLeft());
    }, 1000);

    return () => clearInterval(timer);
  }, [dataProva]);

  return (
    <div className="flex gap-4 justify-center">
      <TimeUnit value={timeLeft.days} label="dias" />
      <TimeUnit value={timeLeft.hours} label="horas" />
      <TimeUnit value={timeLeft.minutes} label="minutos" />
      <TimeUnit value={timeLeft.seconds} label="segundos" />
    </div>
  );
};

const TimeUnit: React.FC<{ value: number; label: string }> = ({ value, label }) => {
  return (
    <div className="flex flex-col items-center p-4 bg-background rounded-lg border w-24">
      <span className="text-4xl font-bold text-primary">{String(value).padStart(2, '0')}</span>
      <span className="text-xs text-muted-foreground uppercase tracking-wider">{label}</span>
    </div>
  );
};

export default Countdown;
